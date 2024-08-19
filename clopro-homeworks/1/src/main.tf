resource "yandex_vpc_network" "network_vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public_subnet" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network_vpc.id
  v4_cidr_blocks = var.public_cidr
}

resource "yandex_vpc_subnet" "private_subnet" {
  name           = "private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network_vpc.id
  route_table_id = yandex_vpc_route_table.netology-routing.id
  v4_cidr_blocks = var.private_cidr
}


