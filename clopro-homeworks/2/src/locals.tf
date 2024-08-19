locals {
    metadata_vm = {
      #serial-port-enable = 1
      ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"   
    }
}
