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
  description = "VPC network&subnet name"
}


#Variables VM WEB
variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Yandex compute image family"
}

variable "count_masters" {
  type        = number
  default     = 1
  description = "Count of Master node"
}

variable "count_workers" {
  type        = number
  default     = 4
  description = "Count of Master node"
}

variable "vms_resources" {
  type = map(object({
      cores=number
      memory=number
      core_fraction=number
 
  }))
  description = "VM Resourses"
}


variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform vCPU"
}


variable "each_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform vCPU"
}


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



variable "ssh-keys" {
  type        = string
  default     = "..."
  description = "SSH keys"
}


