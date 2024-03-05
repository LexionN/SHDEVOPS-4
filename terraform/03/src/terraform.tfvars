vms_resources = {
  web={
    cores=2
    memory=1
    core_fraction=20
},    
each_vm =  { cores=2, memory=1, core_fraction=20 }

}




meta_vm = {
    serial-port-enable = 1
    ssh-keys           = local.ssh-kesy
  }
