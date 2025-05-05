resource "yandex_kubernetes_cluster" "k8s" {
  name        = "regional-k8s"
  network_id  = yandex_vpc_network.default.id

  master {
    version = "1.29"
    regional {
      region = "ru-central1"

      location {
        zone      = "ru-central1-a"
        subnet_id = yandex_vpc_subnet.public_a.id
      }

      location {
        zone      = "ru-central1-b"
        subnet_id = yandex_vpc_subnet.public_b.id
      }

      location {
        zone      = "ru-central1-d"
        subnet_id = yandex_vpc_subnet.public_d.id
      }
    }
    public_ip = true
  }

  service_account_id      = var.k8s_service_account_id
  node_service_account_id = var.k8s_service_account_id

  kms_provider {
    key_id = var.kms_key_id
  }
}
