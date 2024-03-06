locals {
    metadata = {
    serial-port-enable = 1
    ssh-keys           = file("/home/lexion/.ssh/id_ed25519.pub")
    }
}
