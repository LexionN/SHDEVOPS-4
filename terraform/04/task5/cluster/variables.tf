variable "env_name" {
  type    = string
  default = null
  description   = "Имя модуля"
}
variable "name" {
  type    = string
  #default = null
  description   = "<имя_кластера>"
}


variable "name_id" {
  type    = list(string)
  default = ["1", "2"]
  description   = "<id hosts кластера>"
}


 variable "environment" {
   type = string
   default = "PRESTABLE"
   description   = "<окружение>"
   validation {
     condition = contains(["PRESTABLE", "PRODUCTION"], var.environment)
     error_message = "Invalid zone."
   }
  } 

  variable "network_id" {
    type    = string
    description   = "<идентификатор_сети>"
  }
  
variable "version_mysql" {
  type    = string
  default = "8.0"
  description   = "<версия_MySQL>"
}
/* 
variable "security_group_ids" {
  type    = list(string)
  description   = "<список_идентификаторов_групп_безопасности>"
}

*/
 variable resources {
    type = map(object({
      resource_preset_id = string
      disk_type_id       = string
      disk_size          = number
    }))
  default = {    
    res = {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-hdd"
      disk_size          = "10"
    }
  }

}
/*
variable "host_res" {
   type = map(object({
      zone             = string
      subnet_id        = string
      assign_public_ip = bool
      name             = string
   }))
}
*/

variable "HA" {
   type = bool
   default = true
   description   = "HA кластер?"
}