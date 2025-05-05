resource "yandex_vpc_network" "default" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "public_a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.3.0/24"]
  route_table_id = yandex_vpc_route_table.public_rt.id
}

resource "yandex_vpc_subnet" "public_b" {
  name           = "public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.4.0/24"]
  route_table_id = yandex_vpc_route_table.public_rt.id
}

resource "yandex_vpc_subnet" "public_d" {
  name           = "public-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.6.0/24"]
  route_table_id = yandex_vpc_route_table.public_rt.id
}

resource "yandex_vpc_gateway" "internet_gateway" {
  name = "internet-gateway"
}

resource "yandex_vpc_route_table" "public_rt" {
  name       = "public-route-table"
  network_id = yandex_vpc_network.default.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.internet_gateway.id
  }
}

