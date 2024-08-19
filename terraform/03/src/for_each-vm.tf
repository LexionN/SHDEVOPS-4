resource "yandex_compute_instance" "platform_db" {
  for_each = toset([ "main", "replica" ])
  name        = "db-${each.value}"
  platform_id = var.each_platform_id
  resources { 
   cores=var.vms_resources.each_vm.cores
   memory=var.vms_resources.each_vm.memory
   core_fraction=var.vms_resources.each_vm.core_fraction
}
       
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
 } 
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat       = false
  }

  metadata = local.metadata_vm

}
