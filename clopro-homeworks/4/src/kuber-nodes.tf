# Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.
resource "yandex_kubernetes_node_group" "k8s-ng-01" {
  description = "Группа узлов для кластера"
  cluster_id  = yandex_kubernetes_cluster.k8s-regional.id
  name        = "k8s-ng-01"
  instance_template {
    platform_id = "standard-v2"
    container_runtime {
      type = "containerd"
    }
    resources {
      cores=var.vms_resources.nat_vm.cores
      memory=var.vms_resources.nat_vm.memory
      core_fraction=var.vms_resources.nat_vm.core_fraction
    }
  //  network_interface {
  //    nat        = true
  //    subnet_ids = ["${yandex_vpc_subnet.public_subnet[0].id}"]
  //  }
    scheduling_policy {
      preemptible = true
    }
    metadata = local.metadata_vm
  }

  scale_policy {
    auto_scale {
      initial = 3
      max     = 6
      min     = 3
    }
  }
  //allocation_policy {
  //  location {
  //    zone      = local.vpc_zone[0]
  //    subnet_id = yandex_vpc_subnet.public_subnet[0].id
  //  }
  //}

  depends_on = [
    yandex_kubernetes_cluster.k8s-regional,
    yandex_vpc_subnet.public_subnet[0]
  ]

}
