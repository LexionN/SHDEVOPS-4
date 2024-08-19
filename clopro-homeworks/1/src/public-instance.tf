resource "yandex_compute_instance" "public-instance" {
  name = "public-instance"
  hostname = "public-instance"
  zone     = var.default_zone
   resources {
   cores=var.vms_resources.nat_vm.cores
   memory=var.vms_resources.nat_vm.memory
   core_fraction=var.vms_resources.nat_vm.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = "fd8bkgba66kkf9eenpkb"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet.id
    nat=true
    
  }
  metadata = local.metadata_vm
}