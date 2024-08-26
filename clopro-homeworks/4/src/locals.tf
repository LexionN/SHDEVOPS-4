locals {
    metadata_vm = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"   
    }
    vpc_zone = tolist ([
      "ru-central1-a", 
      "ru-central1-b",
      "ru-central1-d"
    ])
}
