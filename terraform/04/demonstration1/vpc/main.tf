#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.env_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop" {
  name           = "${var.env_name}-${var.zone}"
  zone           = var.zone
  network_id = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr
}
 
