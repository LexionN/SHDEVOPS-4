output "vm_output" {
  value       =  {
    platfom = {
      instance_name     = yandex_compute_instance.platform.name 
      external_ip_      = yandex_compute_instance.platform.network_interface.0.nat_ip_address
      fqdn              = yandex_compute_instance.platform.fqdn
    }

 platfom_db = {
      instance_name     = yandex_compute_instance.platform_db.name
      external_ip_      = yandex_compute_instance.platform_db.network_interface.0.nat_ip_address
      fqdn              = yandex_compute_instance.platform_db.fqdn
    }


  }
  description = "The private IP address of the main server instance."
}
