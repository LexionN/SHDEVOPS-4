resource "yandex_compute_disk" "disk" {
  count      = 3
  name       = "disk-${count.index+1}"
  type       = "network-hdd"
  zone       = var.default_zone
  size       = 1
  #block_size = <размер_блока>
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.disk_platform_id
  resources { 
   cores=var.vms_resources.disk_vm.cores
   memory=var.vms_resources.disk_vm.memory
   core_fraction=var.vms_resources.disk_vm.core_fraction
}
       
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
 } 

dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disk[*].id
    content {
      disk_id = secondary_disk.value
    }
    
    
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat       = true
  }

  metadata = local.metadata

}