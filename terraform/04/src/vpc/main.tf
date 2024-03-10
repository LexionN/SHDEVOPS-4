#создаем облачную сеть
resource "yandex_vpc_network" "vpc_net" {
  name = var.env_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "vpc_subnet" {
  for_each = { for v in var.subnets : v.zone => v }
 
  name           = "${var.env_name}-subnet-${each.key}"
#  region       = "europe-central2"
  network_id     = yandex_vpc_network.vpc_net.id
  v4_cidr_blocks = [each.value.cidr]
  zone           = each.value.zone

}
 
