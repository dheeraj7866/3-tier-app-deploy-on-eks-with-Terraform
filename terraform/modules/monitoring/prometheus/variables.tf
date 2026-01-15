variable "namespace" {
  type = string
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

variable "gmail_user" {
  type      = string
  sensitive = true
}

variable "gmail_app_password" {
  type      = string
  sensitive = true
}
