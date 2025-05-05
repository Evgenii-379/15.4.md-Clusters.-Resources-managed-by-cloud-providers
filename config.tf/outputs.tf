output "mysql_cluster_name" {
  value = yandex_mdb_mysql_cluster.mysql_cluster.name
}
output "mysql_db_name" {
  value = "netology_db"
}
output "mysql_user" {
  value = var.mysql_user
}
