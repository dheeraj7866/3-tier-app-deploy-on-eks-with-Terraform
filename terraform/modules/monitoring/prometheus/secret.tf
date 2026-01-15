resource "kubernetes_secret" "grafana_smtp" {
  metadata {
    name      = "grafana-smtp-secret"
    namespace = var.namespace
  }

  data = {
    GF_SMTP_USER     = var.gmail_user
    GF_SMTP_PASSWORD = var.gmail_app_password
  }

  type = "Opaque"
}
