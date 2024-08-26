resource "yandex_compute_instance" "nat-instance" {
  name = "nat-instance"
  hostname = "nat-instance"
  zone     = var.default_zone
   resources {
   cores=var.vms_resources.nat_vm.cores
   memory=var.vms_resources.nat_vm.memory
   core_fraction=var.vms_resources.nat_vm.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet.id
    ip_address = "192.168.10.254"
    nat       = true
  }
  metadata = local.metadata_vm
}