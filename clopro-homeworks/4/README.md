# Домашнее задание к занятию «Кластеры. Ресурсы под управлением облачных провайдеров»

### Цели задания 

1. Организация кластера Kubernetes и кластера баз данных MySQL в отказоустойчивой архитектуре.
2. Размещение в private подсетях кластера БД, а в public — кластера Kubernetes.

---
## Задание 1. Yandex Cloud

1. Настроить с помощью Terraform кластер баз данных MySQL.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость. 

```
locals {
    metadata_vm = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"   
    }
    vpc_zone = tolist ([
      "ru-central1-a", 
      "ru-central1-b",
      "ru-central1-d"
    ])
}
```

```
variable "private_cidr" {
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
```

```
resource "yandex_vpc_subnet" "private_subnet" {
  count          = length(local.vpc_zone)
  name           = "private_${local.vpc_zone[count.index]}"
  zone           = local.vpc_zone[count.index]
  network_id     = yandex_vpc_network.network_vpc.id
  v4_cidr_blocks = [var.private_cidr[count.index]]
  route_table_id = yandex_vpc_route_table.netology-routing.id
}
```
 
 - Разместить ноды кластера MySQL в разных подсетях.
 - Необходимо предусмотреть репликацию с произвольным временем технического обслуживания.
 - Использовать окружение Prestable, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.

![image](https://github.com/user-attachments/assets/16685fad-e278-4cfe-ac2e-79ec9560f461)
 
 - Задать время начала резервного копирования — 23:59.
 - Включить защиту кластера от непреднамеренного удаления.

```
resource "yandex_mdb_mysql_cluster" "my_cluster" {
  name        = "MySQL_Cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.network_vpc.id
  version     = "8.0"

  resources {
    resource_preset_id = "b2.medium" // не возможно создать ноду кластера в сети ru-central-d на платформе Intel Broadwell, используем Intel Cascade Lake
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }
  
  deletion_protection = true
  
 
  dynamic "host" {
    for_each    = toset(range (0,length(local.vpc_zone)))
    content {
      zone      = local.vpc_zone[host.value]
      name      = "first-node-${host.value+1}"
      subnet_id = yandex_vpc_subnet.private_subnet[host.value].id
    }
  }
  
}
```

 - Создать БД с именем `netology_db`, логином и паролем.

```
resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = "netology_db"
  depends_on = [yandex_mdb_mysql_cluster.my_cluster]
}

resource "yandex_mdb_mysql_user" "netology_user" {
	cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = var.db_username
  password   = var.db_password
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
  depends_on = [
    yandex_mdb_mysql_database.netology_db
  ]

}
```

2. Настроить с помощью Terraform кластер Kubernetes.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость.

```
resource "yandex_vpc_subnet" "public_subnet" {
  count          = length(local.vpc_zone)
  name           = "public_${local.vpc_zone[count.index]}"
  zone           = local.vpc_zone[count.index]
  network_id     = yandex_vpc_network.network_vpc.id
  v4_cidr_blocks = [var.public_cidr[count.index]]
  route_table_id = yandex_vpc_route_table.netology-routing.id
}
```
 
 - Создать отдельный сервис-аккаунт с необходимыми правами.

```
resource "yandex_iam_service_account" "kuber-sa-account" {
  description = "Сервисный аккаунт для кластера K8S"
  name        = "sa-kuber"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  # Сервисному аккаунту назначается роль "k8s.clusters.agent".
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "kuber-sa-lb-admin" {
  # Сервисному аккаунту назначается роль "load-balancer.admin" - даем возможность создавать сервис типа LoadBalancer.
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
}

resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "kms-key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" # 1 год.
}

resource "yandex_kms_symmetric_key_iam_binding" "viewer" {
  # Даем сервисному аккаунту доступ к ключу шифрования.
  symmetric_key_id = yandex_kms_symmetric_key.kms-key.id
  role             = "viewer"
  members          = [
    "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
  ]
}
```

 - Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.
 - Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.

```
resource "yandex_kubernetes_cluster" "k8s-regional" {
  description        = "Кластер K8S"
  name               = "vp-k8s-cluster-01"
  network_id         = yandex_vpc_network.network_vpc.id
  cluster_ipv4_range = "10.1.0.0/16"
  service_ipv4_range = "10.2.0.0/16"
  master {
    version   = "1.29"
    public_ip = true
    regional {
      region = "ru-central1"
      
      dynamic "location" {
        for_each    = toset(range (0,length(local.vpc_zone)))
          content {
            zone      = local.vpc_zone[location.value]
            subnet_id = yandex_vpc_subnet.private_subnet[location.value].id
          }
      }
    }
  }
  service_account_id      = yandex_iam_service_account.kuber-sa-account.id
  node_service_account_id = yandex_iam_service_account.kuber-sa-account.id

 kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.kuber-sa-lb-admin,
    yandex_kms_symmetric_key.kms-key,
    yandex_kms_symmetric_key_iam_binding.viewer
  ]
 }
```

 - Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.

```
# Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.
resource "yandex_kubernetes_node_group" "k8s-ng" {
  count          = length(local.vpc_zone)  
  description = "Группа узлов для кластера на ${local.vpc_zone[count.index]}"
  cluster_id  = yandex_kubernetes_cluster.k8s-regional.id
  name        = "k8s-ng-${local.vpc_zone[count.index]}"
  instance_template {
    platform_id = "standard-v3"
    container_runtime {
      type = "containerd"
    }
    resources {
      cores=var.vms_resources.nat_vm.cores
      memory=var.vms_resources.nat_vm.memory
      core_fraction=var.vms_resources.nat_vm.core_fraction
    }
    boot_disk {
      type = "network-ssd"
      size = 30
    }
    network_interface {
  //    nat        = false
      subnet_ids = ["${yandex_vpc_subnet.public_subnet[count.index].id}"]
    }
    scheduling_policy {
      preemptible = true
    }
    metadata = local.metadata_vm
  }

  scale_policy {
    auto_scale {
      initial = 1    // Т.к. сетей объявлено 3, поэтому по заданию, 3 ноды в разных подсетях изначально
      max     = 2    // Максимально 6, по 2 в каждой подсети.
      min     = 1
    }
  }
  allocation_policy {
    location {
      zone      = local.vpc_zone[count.index]
     // subnet_id = yandex_vpc_subnet.public_subnet[count.index].id
    }
  }

  depends_on = [ 
    yandex_kubernetes_cluster.k8s-regional
  ]

}
```

 
 - Подключиться к кластеру с помощью `kubectl`.

```
resource "null_resource" "phpmyadmin_deploy" {
  depends_on = [yandex_kubernetes_node_group.k8s-ng]
  triggers = {
    always_run = timestamp()
  }
  #Подключение к кластеру K8S
   provisioner "local-exec" {
   command = "yc managed-kubernetes cluster get-credentials '${yandex_kubernetes_cluster.k8s-regional.id}' --external --force"
   }

#Деплой phpmyadmin
  provisioner "local-exec" {
    command = <<EOT
      export PMA_HOST1=${yandex_mdb_mysql_cluster.my_cluster.host[0].fqdn}; \
      export PMA_DB1=${yandex_mdb_mysql_database.netology_db.name}; \
      export PMA_USER1=${var.db_username}; \
      export PMA_PASSWORD1=${var.db_password}; \
      envsubst < ./deploy/phpmyadmin-deploy.yaml | kubectl apply -f -
    EOT
  } 
#Деплой LoadBalancer
  provisioner "local-exec" {
    command = "kubectl apply -f ./deploy/phpmyadmin-service.yaml"
  }
}
```
 
 - *Запустить микросервис phpmyadmin и подключиться к ранее созданной БД.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: phpmyadmin-deployment
  labels:
    app: phpmyadmin
spec:
  replicas: 1
  selector:
    matchLabels:
      app: phpmyadmin
  template:
    metadata:
      labels:
        app: phpmyadmin
    spec:
      containers:
        - name: phpmyadmin
          image: phpmyadmin/phpmyadmin
          ports:
            - containerPort: 80
          env:
            - name: PMA_HOST
              value: $PMA_HOST1
            - name: PMA_DB
              value: $PMA_DB1
            - name: PMA_USER
              value: $PMA_USER1
            - name: PMA_PASSWORD
              value: $PMA_PASSWORD1

```
 
 - *Создать сервис-типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД.

```
apiVersion: v1
kind: Service
metadata:
  name: phpmyadmin-service
spec:
  type: LoadBalancer
  selector:
    app: phpmyadmin
  ports:
  - name: http
    port: 80
    targetPort: 80

```

Конфигурация написана для обеспечения минимального действия пользователя, всё поднимается и разворачивается только по команде ```terraform -apply```, после отработки и поднятия ресурсов, необходимо только посмотреть адрес ingress сервиса командой ```kubectl describe service/phpmyadmin-service```


Полезные документы:

- [MySQL cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster).
- [Создание кластера Kubernetes](https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create)
- [K8S Cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster).
- [K8S node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group).

--- 
## Задание 2*. Вариант с AWS (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

1. Настроить с помощью Terraform кластер EKS в три AZ региона, а также RDS на базе MySQL с поддержкой MultiAZ для репликации и создать два readreplica для работы.
 
 - Создать кластер RDS на базе MySQL.
 - Разместить в Private subnet и обеспечить доступ из public сети c помощью security group.
 - Настроить backup в семь дней и MultiAZ для обеспечения отказоустойчивости.
 - Настроить Read prelica в количестве двух штук на два AZ.

2. Создать кластер EKS на базе EC2.

 - С помощью Terraform установить кластер EKS на трёх EC2-инстансах в VPC в public сети.
 - Обеспечить доступ до БД RDS в private сети.
 - С помощью kubectl установить и запустить контейнер с phpmyadmin (образ взять из docker hub) и проверить подключение к БД RDS.
 - Подключить ELB (на выбор) к приложению, предоставить скрин.

Полезные документы:

- [Модуль EKS](https://learn.hashicorp.com/tutorials/terraform/eks).

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
