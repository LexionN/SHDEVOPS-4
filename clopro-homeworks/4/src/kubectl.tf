resource "null_resource" "phpmyadmin_deploy" {
  depends_on = [yandex_kubernetes_node_group.k8s-ng]
  triggers = {
    always_run = timestamp()
  }
  #Подключение к кластеру K8S
   provisioner "local-exec" {
   command = "yc managed-kubernetes cluster get-credentials '${yandex_kubernetes_cluster.k8s-regional.id}' --external --force"
   }

#Деплой phpmyadmin
  provisioner "local-exec" {
    command = <<EOT
      export PMA_HOST1=${yandex_mdb_mysql_cluster.my_cluster.host[0].fqdn}; \
      export PMA_DB1=${yandex_mdb_mysql_database.netology_db.name}; \
      export PMA_USER1=${var.db_username}; \
      export PMA_PASSWORD1=${var.db_password}; \
      envsubst < ./deploy/phpmyadmin-deploy.yaml | kubectl apply -f -
    EOT
  } 
#Деплой LoadBalancer
  provisioner "local-exec" {
    command = "kubectl apply -f ./deploy/phpmyadmin-service.yaml"
  }
}