variable "yc_token" {}
variable "cloud_id" {}
variable "folder_id" {}
variable "network_id" {}
variable "mysql_user" {
  default = "netology"
}
variable "mysql_password" {
  sensitive = true
}

variable "ssh_public_key_path" {
  description = "Путь до публичного SSH-ключа"
  default     = "~/.ssh/id_ed25519"
}

variable "k8s_service_account_id" {
  description = "ID существующего сервисного аккаунта для Kubernetes"
  type        = string
}

variable "kms_key_id" {
  description = "ID существующего симметричного ключа KMS"
  type        = string
}
