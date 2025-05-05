resource "yandex_kubernetes_node_group" "default" {
  cluster_id = yandex_kubernetes_cluster.k8s.id
  name       = "k8s-node-group"
  version    = "1.29"

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"  
    }
  }

  instance_template {
    platform_id = "standard-v1"

    resources {
      cores  = 2
      memory = 4
      core_fraction = 20
    }

    boot_disk {
      type = "network-ssd"
      size = 50
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public_a.id]  
      nat        = true
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
      ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
    }
  }
}
