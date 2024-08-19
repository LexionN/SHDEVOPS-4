output "vm_output" {
  value = [[for vm in concat(yandex_compute_instance.platform, values(yandex_compute_instance.platform_db)) : {
    instance_name = vm.name,
    instance_id   = vm.id,
    instance_fqdn = vm.fqdn
    instance_ssh-key = vm.metadata.ssh-keys
  }]]
}
