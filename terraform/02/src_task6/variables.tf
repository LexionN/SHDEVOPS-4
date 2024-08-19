###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}



###ssh vars

#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3v9g02B9BMGP4/ACgME11e5UknvRBu38xd4vXs72zy lexion@admin-ubuntu"
#  description = "ssh-keygen -t ed25519"
#}


variable "metadata_vm" {
  type = map(object({
    serial-port-enable = number
    ssh-keys = string
  }))
 default = {
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3v9g02B9BMGP4/ACgME11e5UknvRBu38xd4vXs72zy lexion@admin-ubuntu"
  
  }
 }

}



variable "env" {
  type        = string
  default     = "netology"
  description = "Local variable env"
}

variable "project" {
  type        = string
  default     = "develop"
  description = "Local variable project"
}

variable "role_web" {
  type        = string
  default     = "platform-web"
  description = "Local variable role"
}

variable "role_db" {
  type        = string
  default     = "platform-db"
  description = "Local variable role"
}
