variable "env_name" {
  type    = string
  default = null
  description   = "Имя модуля"
}

variable "zone" {
   type          = string
   default       = "ru-central1-a"
   description   = "Зона сети"
   validation {
     condition = contains(["ru-central1-a", "ru-central1-b", "ru-central1-d"], var.zone)
     error_message = "Invalid zone."
   }
}

#variable "cidr" {
#  type        = list(string)
#  default     = ["10.0.1.0/24"]
#  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
#}


variable "subnets" {
   type  = list(object({ zone = string, cidr = string }))
   default = [
      {zone = "ru-central1-a", cidr = "10.0.1.0/24"}
   ]
   description   = "Зона сети"
}
