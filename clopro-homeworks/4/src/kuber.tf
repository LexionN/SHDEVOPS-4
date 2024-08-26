resource "yandex_kubernetes_cluster" "k8s-regional" {
  description        = "Кластер K8S"
  name               = "vp-k8s-cluster-01"
  network_id         = yandex_vpc_network.network_vpc.id
  cluster_ipv4_range = "10.1.0.0/16"
  service_ipv4_range = "10.2.0.0/16"
  master {
    version   = "1.29"
    public_ip = true
    # Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.
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

  #  Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.
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



