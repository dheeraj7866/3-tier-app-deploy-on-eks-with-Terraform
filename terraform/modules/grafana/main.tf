resource "helm_release" "grafana" {
  name       = "grafana-smtp"
  namespace  = var.namespace
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  values = [<<EOF
adminPassword: "${var.admin_password}"

grafana.ini:
  smtp:
    enabled: true
    host: smtp.gmail.com:587
    user: ${var.gmail_user}
    password: ${var.gmail_app_password}
    from_address: ${var.gmail_user}
    from_name: Grafana Alerts
EOF
  ]
}
