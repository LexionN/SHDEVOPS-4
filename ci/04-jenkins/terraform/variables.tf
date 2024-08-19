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
<<<<<<< HEAD
  default     = "centos-7"
=======
  default     = "centos-stream-8"
>>>>>>> refs/remotes/origin/main
  description = "Yandex compute image family"
}

variable "vms_resources" {
  type = map(object({
      cores=number
      memory=number
      core_fraction=number
 
  }))
  description = "VM Resourses"
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
    ssh-keys           = "user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClIJ+cQBgozFhx/8CA3m4p3cRDuUmCVMq4hOuCLda0J8CK3oaDKpJzlWiniQivZKhNe8ns3K9lgv8baEevhQGUzA6eC8Yu9k1IQDjbX4NrCSB5qbpirBDxUrb9RvuI3j+2H+pvPmIDd82E0Db4VcC9u0JJ+k46IDWm7gJ2tuDwSXNxEXvanPUESnaFg8uHMEyoR6067F/kXhP5BAUH59i3bU2oqJFClc9H7ZAnTnbzcPQwzHakCt6GrrYUnCmKQ/o7mYkaCXKyKXezC9c1zyGkxqqp4tsshtuvMmlRRm3jKMwcP9BVY/UE5CKrpiQClhqX0Xcr2Lc4S9hcN0pAXMicVC91QLnpEHDNZrWz6MFsQcuzSjPr0krh3rBOLaQSbh1Ks9oQjPh9ewk4nWlnd4Y9l+kb01bUQjbE64/krvzNobwrSbmcvKZePanHGL9m7LrIAA5VQxhWnTLebcj+vQ4ql9iSXltgO1F09Fq/1UCJV2U9pYw2D4+p5b2BnOpI9fE="
  
  }
 }

}


