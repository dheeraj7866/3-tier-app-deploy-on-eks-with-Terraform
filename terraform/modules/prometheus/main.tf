resource "helm_release" "prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  values = [<<EOF
grafana:
  enabled: true

alertmanager:
  enabled: true

prometheus:
  prometheusSpec:
    retention: 7d
EOF
  ]
}
