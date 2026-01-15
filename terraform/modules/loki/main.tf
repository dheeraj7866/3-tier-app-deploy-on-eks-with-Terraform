resource "helm_release" "loki" {
  name       = "loki-stack"
  namespace  = var.namespace
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"

  values = [<<EOF
loki:
  enabled: true

promtail:
  enabled: true
EOF
  ]
}
