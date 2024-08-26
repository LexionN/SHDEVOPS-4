resource "yandex_vpc_network" "network_vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public_subnet" {

  count          = length(local.vpc_zone)
  name           = "public_${local.vpc_zone[count.index]}"
  zone           = local.vpc_zone[count.index]
  network_id     = yandex_vpc_network.network_vpc.id
  v4_cidr_blocks = [var.public_cidr[count.index]]
}

resource "yandex_vpc_subnet" "private_subnet" {

  count          = length(local.vpc_zone)
  name           = "private_${local.vpc_zone[count.index]}"
  zone           = local.vpc_zone[count.index]
  network_id     = yandex_vpc_network.network_vpc.id
  v4_cidr_blocks = [var.private_cidr[count.index]]
}


