output "picture_url" {
  value = "https://${yandex_storage_bucket.my_bucket.bucket_domain_name}/${yandex_storage_object.cute-picture.key}"
}

output "ipaddress_group1" {
  value = yandex_compute_instance_group.group1.instances[*].network_interface[0].ip_address
}

output "nlb_address" {
  value = yandex_lb_network_load_balancer.nlb.listener.*.external_address_spec[0].*.address
}
