resource "helm_release" "prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  timeout          = 900
  wait             = true
  atomic           = true
  cleanup_on_fail  = true

  values = [<<EOF
grafana:
  enabled: true
  adminPassword: "${var.grafana_admin_password}"

  grafana.ini:
    smtp:
      enabled: true
      host: smtp.gmail.com:587
      user: ${var.gmail_user}
      password: ${var.gmail_app_password}
      from_address: ${var.gmail_user}
      from_name: Grafana Alerts

alertmanager:
  enabled: true

prometheus:
  prometheusSpec:
    retention: 7d
EOF
  ]
}
