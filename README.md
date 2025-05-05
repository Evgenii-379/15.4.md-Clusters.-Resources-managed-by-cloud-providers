# Домашнее задание к занятию «Кластеры. Ресурсы под управлением облачных провайдеров»-***Вуколов Евгений***
 
### Цели задания 
 
1. Организация кластера Kubernetes и кластера баз данных MySQL в отказоустойчивой архитектуре.
2. Размещение в private подсетях кластера БД, а в public — кластера Kubernetes.
 
---
## Задание 1. Yandex Cloud
 
1. Настроить с помощью Terraform кластер баз данных MySQL.
 
 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость. 
 - Разместить ноды кластера MySQL в разных подсетях.
 - Необходимо предусмотреть репликацию с произвольным временем технического обслуживания.
 - Использовать окружение Prestable, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.
 - Задать время начала резервного копирования — 23:59.
 - Включить защиту кластера от непреднамеренного удаления.
 - Создать БД с именем `netology_db`, логином и паролем.
 
2. Настроить с помощью Terraform кластер Kubernetes.
 
 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость.
 - Создать отдельный сервис-аккаунт с необходимыми правами. 
 - Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.
 - Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.
 - Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.
 - Подключиться к кластеру с помощью `kubectl`.
 - *Запустить микросервис phpmyadmin и подключиться к ранее созданной БД.
 - *Создать сервис-типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД.
 
Полезные документы:
 
- [MySQL cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster).
- [Создание кластера Kubernetes](https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create)
- [K8S Cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster).
- [K8S node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group).
 
--- 
## Задание 2*. Вариант с AWS (задание со звёздочкой)
 
Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.
 
**Что нужно сделать**
 
1. Настроить с помощью Terraform кластер EKS в три AZ региона, а также RDS на базе MySQL с поддержкой MultiAZ для репликации и создать два readreplica для работы.
 
 - Создать кластер RDS на базе MySQL.
 - Разместить в Private subnet и обеспечить доступ из public сети c помощью security group.
 - Настроить backup в семь дней и MultiAZ для обеспечения отказоустойчивости.
 - Настроить Read prelica в количестве двух штук на два AZ.
 
2. Создать кластер EKS на базе EC2.
 
 - С помощью Terraform установить кластер EKS на трёх EC2-инстансах в VPC в public сети.
 - Обеспечить доступ до БД RDS в private сети.
 - С помощью kubectl установить и запустить контейнер с phpmyadmin (образ взять из docker hub) и проверить подключение к БД RDS.
 - Подключить ELB (на выбор) к приложению, предоставить скрин.
 
Полезные документы:
 
- [Модуль EKS](https://learn.hashicorp.com/tutorials/terraform/eks).
 
### Правила приёма работы
 
Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.


# **Решение**

## **Задание 1 **

## **Часть 1**

1. Используя настройки VPC из предыдущих домашних заданий, добавил дополнительно подсеть private в разных зонах, а именно в зоне ru-central1-a и ru-central1-b,
чтобы обеспечить отказоустойчивость. В зоне ru-central1-d с параметрами: окружение Prestable, платформа Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб,
установить не получилось, поэтому для этой части задания я использовал только 2 зоны.
 
```
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

resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name                = "netology-cluster"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.default.id
  version             = "8.0"
  deletion_protection = false

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }
```
- Здесь я испоьзовал класс хоста "b1.medium" с платформо Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.

- Задал время начала резервного копирования — 23:59:

```

  backup_window_start {
    hours   = 23
    minutes = 59
  }
```
- Включил защиту кластера от непреднамеренного удаления, 
- Создал БД с именем `netology_cluster`, логином и паролем:

```
resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name                = "netology-cluster"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.default.id
  version             = "8.0"
  deletion_protection = true
```
- Настроил репликацию с произвольным временем технического обслуживания:

```
 maintenance_window {
    type = "ANYTIME"
  }
```
 
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-02%20215600.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-02%20215725.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-02%20215747.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-02%20215804.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-02%20215820.png)

## **Часть 2**

- Так как у меня с предыдущих заданий в YC остался сервис аккуант с KMS ключём, я применил их.
- Добавил дополнительно подсети public в разных зонах : 

```
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

```
- Создал региональный мастер Kubernetes с размещением нод в трёх разных подсетях:

```

resource "yandex_kubernetes_cluster" "k8s" {
  name        = "regional-k8s"
  network_id  = yandex_vpc_network.default.id

  master {
    version = "1.29"
    regional {
      region = "ru-central1"
```

- А так же создал группу узлов, состояющую из трёх машин с автомасштабированием до шести.
Автомасштабирование: 

```
scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }
```
- Что бы использовать все три зоны ru-central1-a, ru-central1-b, ru-central1-d для кластера MySQl я внёс изменения в настройки и вместо класса хоста "b1.medium",
использовал класс хоста "b2.medium" с платформо Intel Cascade Lake с производительностью 50% CPU и размером диска 20 Гб

```
resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

```
- Скриншоты : 

- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-05%20143049.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-05%20143141.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-05%20143206.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-05%20143227.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-05%20160144.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-05%20160221.png)
- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-05%20160235.png)

- Подключаюсь к кластеру с помощью `kubectl`, вывод команды `kubectl get nodes` и `kubectl cluster info` :

- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-05%20144301.png)

- Вывод названия кластера MySQL :

- ![scrin](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/Снимок%20экрана%202025-05-05%20155540.png)


- Манифесты конфигурации инфраструктуры : 

[k8s_cluster.tf](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/config.tf/k8s_cluster.tf)

[k8s_nodes.tf](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/config.tf/k8s_nodes.tf)

[main.tf](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/config.tf/main.tf)

[outputs.tf](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/config.tf/outputs.tf)

[subnets.tf](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/config.tf/subnets.tf)

[terraform.tfvars](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/config.tf/terraform.tfvars)

[variables.tf](https://github.com/Evgenii-379/15.4.md-Clusters.-Resources-managed-by-cloud-providers/blob/main/config.tf/variables.tf)







































