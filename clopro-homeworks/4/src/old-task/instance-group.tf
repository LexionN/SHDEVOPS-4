resource "yandex_iam_service_account" "sa-group" {
  name        = "sa-group"
}
resource "yandex_resourcemanager_folder_iam_member" "roleassignment-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-group.id}"
}


resource "yandex_compute_instance_group" "group1" {
  name                = "test-ig"
  folder_id           = var.folder_id
  service_account_id  = yandex_iam_service_account.sa-group.id
  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    resources {
      cores=var.vms_resources.nat_vm.cores
      memory=var.vms_resources.nat_vm.memory
      core_fraction=var.vms_resources.nat_vm.core_fraction
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      
      }
    }
    network_interface {
      network_id = yandex_vpc_network.network_vpc.id
      subnet_ids = [yandex_vpc_subnet.public_subnet.id]
    }
    
    metadata = {
       ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
       user-data = "#!/bin/bash\n cd /var/www/html\n echo \"<html><h1>The netology web-server with a network load balancer. IP address using VM is $(hostname -I)</h1><img src='https://${yandex_storage_bucket.my_bucket.bucket_domain_name}/${yandex_storage_object.cute-picture.key}'></html>\" > index.html"
 
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 2
    max_expansion   = 2
  }

  load_balancer {
    target_group_name = "group1"
  }

  health_check {
    interval = 15
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
    http_options {
      path = "/"
      port = 80
    }

  }
 
}
