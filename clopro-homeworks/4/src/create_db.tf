resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = "netology_db"
  depends_on = [yandex_mdb_mysql_cluster.my_cluster]
}

resource "yandex_mdb_mysql_user" "netology_user" {
	cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = var.db_username
  password   = var.db_password
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
  depends_on = [
    yandex_mdb_mysql_database.netology_db
  ]

}
