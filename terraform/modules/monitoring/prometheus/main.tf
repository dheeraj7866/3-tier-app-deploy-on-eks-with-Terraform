resource "helm_release" "prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  timeout         = 900
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  values = [<<EOF
grafana:
  enabled: true
  adminPassword: "${var.grafana_admin_password}"

  envFromSecret: grafana-smtp-secret

  grafana.ini:
    smtp:
      enabled: true
      host: smtp.gmail.com:587
      user: $__env{GF_SMTP_USER}
      password: $__env{GF_SMTP_PASSWORD}
      from_address: $__env{GF_SMTP_USER}
      from_name: Grafana Alerts

alertmanager:
  enabled: true

prometheus:
  prometheusSpec:
    retention: 7d
EOF
  ]

  depends_on = [kubernetes_secret.grafana_smtp]
}
