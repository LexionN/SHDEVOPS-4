resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers = yandex_compute_instance.platform[*],
      databases  = yandex_compute_instance.platform_db,
      storages   = yandex_compute_instance.storage[*]
  })
  filename = "${abspath(path.module)}/hosts.cfg"
}


resource "null_resource" "web_hosts_provision" {
depends_on = [yandex_compute_instance.platform]
#Добавление ssh ключа в ssh-agent
 provisioner "local-exec" {
 command = "echo '${local.metadata_vm.ssh-keys}' | ssh-add"
 }
#Запуск ansible-playbook
 provisioner "local-exec" {
   command = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i hosts.cfg test.yml"
#   interpreter = ["bash"]
#   environment = { 
#     ANSIBLE_HOST_KEY_CHECKING = "False" 
#   }
#   triggers = { 
#     always_run = "${timestamp()}" 
#   }
} 

}
