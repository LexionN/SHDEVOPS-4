resource "yandex_mdb_mysql_cluster" "my_cluster" {
  name        = "MySQL_Cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.network_vpc.id
  version     = "8.0"

  resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }
  
  deletion_protection = false
  
 
  dynamic "host" {
    for_each    = toset(range (0,length(local.vpc_zone)))
    content {
      zone      = local.vpc_zone[host.value]
      name      = "first-node-${host.value+1}"
      subnet_id = yandex_vpc_subnet.private_subnet[host.value].id
    }
  }
  
}
