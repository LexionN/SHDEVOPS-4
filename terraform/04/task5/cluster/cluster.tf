
resource "yandex_mdb_mysql_cluster" "cluster" {
  name        = var.name
  environment = var.environment
  network_id  = var.network_id
  version     = var.version_mysql
  resources {
    resource_preset_id = var.resources["res"].resource_preset_id
    disk_type_id       = var.resources["res"].disk_type_id
    disk_size          = var.resources["res"].disk_size
  }
 dynamic "host" {
    for_each = var.HA ? {1:"ru-central1-a",2:"ru-central1-a"} : {1:"ru-central1-a"}
    content {
      zone      = host.value
      subnet_id = var.network_id
    }
  }
  
}
