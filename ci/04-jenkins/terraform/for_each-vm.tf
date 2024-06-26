resource "yandex_compute_instance" "platform" {
  for_each = toset([ "master", "agent" ])
  name        = "jenkins-${each.value}"
  platform_id = var.each_platform_id
  resources { 
   cores=var.vms_resources.each_vm.cores
   memory=var.vms_resources.each_vm.memory
   core_fraction=var.vms_resources.each_vm.core_fraction
}
       
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.image_id
    }
 } 
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    #security_group_ids = [yandex_vpc_security_group.example.id]
    nat       = true
  }

  metadata = local.metadata_vm

}
