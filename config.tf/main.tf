terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_vpc_subnet" "private_a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "private_b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

resource "yandex_vpc_subnet" "private_d" {
  name           = "private-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.5.0/24"]
}

resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name                = "netology-cluster"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.default.id
  version             = "8.0"
  deletion_protection = false

  resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  maintenance_window {
    type = "ANYTIME"
  }

  mysql_config = {
    sql_mode = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION"
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.private_a.id
    assign_public_ip = false
    name             = "mysql-host-a"
  }

  host {
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.private_b.id
    assign_public_ip = false
    name             = "mysql-host-b"
  }

  host {
    zone             = "ru-central1-d"
    subnet_id        = yandex_vpc_subnet.private_d.id
    assign_public_ip = false
    name             = "mysql-host-d"
  }
}

resource "yandex_mdb_mysql_database" "mydb" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "mydb"
}

resource "yandex_mdb_mysql_user" "user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = var.mysql_user
  password   = var.mysql_password

  permission {
    database_name = yandex_mdb_mysql_database.mydb.name
    roles         = ["ALL"]
  }
}
