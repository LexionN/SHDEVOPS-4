resource "yandex_compute_instance" "platform_worker" {
  count = var.count_workers
  name        = "worker-${count.index+1}"
  platform_id = var.each_platform_id
  resources {
   cores=var.vms_resources.workers_vm.cores
   memory=var.vms_resources.workers_vm.memory
   core_fraction=var.vms_resources.workers_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
  }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat = true
    }

  scheduling_policy {
    preemptible = true
  }

  metadata = local.metadata_vm

}

