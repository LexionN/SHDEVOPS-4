resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      masters = yandex_compute_instance.platform_master[*],
      workers  = yandex_compute_instance.platform_worker[*]
    })
  filename = "${abspath(path.module)}/hosts.cfg"
}


resource "null_resource" "masters_hosts_provision" {
  depends_on = [yandex_compute_instance.platform_master]
#Добавление ssh ключа в ssh-agent
  provisioner "local-exec" {
  command = "echo '${local.metadata_vm.ssh-keys}' | ssh-add"
  }
}

resource "null_resource" "workers_hosts_provision" {
  depends_on = [yandex_compute_instance.platform_worker]
#Добавление ssh ключа в ssh-agent
  provisioner "local-exec" {
  command = "echo '${local.metadata_vm.ssh-keys}' | ssh-add"
  }
}

resource "null_resource" "kubeadm_install_k8s" {
  depends_on = [local_file.hosts_cfg]
#Запуск ansible-playbook
  provisioner "local-exec" {
  command = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i hosts.cfg kubeadm.yml"
  } 

}
