resource "local_file" "hosts_yml" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      databases  = yandex_compute_instance.platform,
    })
  filename = "${abspath(path.module)}/../infrastructure/inventory/cicd/hosts.yml"
}


resource "null_resource" "web_hosts_provision" {
depends_on = [yandex_compute_instance.platform]
#Добавление ssh ключа в ssh-agent
 provisioner "local-exec" {
 command = "echo '${local.metadata_vm.ssh-keys}' | ssh-add"
 }
#Запуск ansible-playbook
 provisioner "local-exec" {
   command = "export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook -T 300 -i ${abspath(path.module)}/../infrastructure/inventory/cicd/hosts.yml ${abspath(path.module)}/../infrastructure/site.yml"
   interpreter = ["/bin/bash", "-c"]
#   environment = { 
#     ANSIBLE_HOST_KEY_CHECKING = "False" 
 #  }
 #  triggers = { 
 #    always_run = "${timestamp()}" 
 #  }
} 

}
