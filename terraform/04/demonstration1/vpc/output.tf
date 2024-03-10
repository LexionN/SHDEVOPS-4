output "network_id" {
    description = "ID сети"
    value =  yandex_vpc_network.develop.id
}


output "subnet_id" {
    value = yandex_vpc_subnet.develop.id  
    description = "ID подсети"

}
