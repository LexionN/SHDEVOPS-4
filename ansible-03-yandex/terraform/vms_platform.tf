#Variables VM WEB
variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Yandex compute image family"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform vCPU"
}


#Variables VM DB 

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Yandex compute image family"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "VM name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform vCPU"
}

variable "vms_resources" {
  type = map(object({
      cores=number
      memory=number
      core_fraction=number
 
  }))
  description = "VM Resourses"
}
