#!/bin/bash

# cleanup-k8s-resources.sh
# Run this before terraform destroy

set -e

# Prompt for cluster name if not passed
if [ -z "$1" ]; then
  read -p "Enter EKS Cluster Name: " CLUSTER_NAME
else
  CLUSTER_NAME="$1"
fi

# Prompt for region if not passed
if [ -z "$2" ]; then
  read -p "Enter AWS Region (default: us-west-1): " REGION
  REGION="${REGION:-us-west-1}"
else
  REGION="$2"
fi

echo "🧹 Cleaning up Kubernetes resources before Terraform destroy..."
echo "📍 Cluster: $CLUSTER_NAME"
echo "📍 Region: $REGION"

# Update kubeconfig
eksctl utils write-kubeconfig --region "$REGION" --cluster "$CLUSTER_NAME"

echo "📋 Listing all ingresses..."
kubectl get ingress --all-namespaces || true

echo "🗑️  Deleting all ingresses (this will remove load balancers)..."
kubectl delete ingress --all --all-namespaces --timeout=300s || true

echo "🗑️  Deleting services of type LoadBalancer..."
kubectl get svc --all-namespaces -o json | \
  jq -r '.items[] | select(.spec.type=="LoadBalancer") | "\(.metadata.namespace) \(.metadata.name)"' | \
  while read namespace name; do
    echo "Deleting LoadBalancer service: $namespace/$name"
    kubectl delete svc "$name" -n "$namespace" --timeout=300s || true
  done

echo "⏳ Waiting for load balancers to be fully deleted..."
sleep 60

echo "🔍 Checking for remaining AWS load balancers..."
aws elbv2 describe-load-balancers --region "$REGION" \
  --query 'LoadBalancers[?contains(LoadBalancerName, `k8s`)].LoadBalancerName' \
  --output table || true

echo "✅ Cleanup complete! You can now run terraform destroy"
