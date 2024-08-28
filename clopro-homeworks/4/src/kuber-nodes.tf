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
      initial = 1
      max     = 2
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
