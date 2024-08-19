variable "ip_address" {
 type = string
 default = "192.168.0.1"
 description = "ip-адрес"
 validation {
   condition = can(cidrhost("${var.ip_address}/31", 1) == var.ip_address)
   error_message = "Invalid ip address."
} 
}

variable "list_ip_address" {
 type = list(string)
 default = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]
 description = "ip-адрес"
 validation {
   condition = alltrue([
     for ip in var.list_ip_address : can(cidrhost("${ip}/31", 1))
   ])
   error_message = "Invalid ip address in list."
}
}
