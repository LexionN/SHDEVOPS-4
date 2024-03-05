data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}


#data "yandex_compute_image" "ubuntu" {

#  family = var.vm_web_family
#}
resource "yandex_compute_instance" "platform" {
  depends_on = [yandex_compute_instance.platform_db]
  count = var.count_web
  name        = "web-${count.index+1}"
  platform_id = var.vm_web_platform_id
  resources {
   cores=var.vms_resources.web.cores
   memory=var.vms_resources.web.memory
   core_fraction=var.vms_resources.web.core_fraction

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
    nat       = true
  }

  metadata = var.metadata_vm["metadata"]

}
