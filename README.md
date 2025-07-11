
# Equity Realstate Infrastructure Automation

This repository automates the provisioning of AWS EKS infrastructure and deployment of applications using Jenkins and Terraform.

---

## 🔧 What This Does

- Provisions AWS infrastructure (VPC, EKS cluster, node groups, etc.) using Terraform.
- Installs essential Kubernetes addons (ALB controller, EBS CSI driver, etc.) after infra setup.
- Deploys application pods (backend/frontend) to the EKS cluster.
- Generates a LoadBalancer service for external access.
- Supports safe teardown (destroy) of infrastructure after verification.

---

## 📁 Directory Structure

terraform/
└── environment/dev/dev-infra/   # Main infra creation (VPC, EKS)
└── environment/dev/eks-addons-install/ # Add-ons for EKS (ALB, EBS, etc.)

---

## 🚀 How to Use

### 1. ✅ **Configure Your Values**

Edit your environment-specific `.tfvars` file:

terraform/environment/dev/dev-infra/terraform.tfvars

Set values like:

```hcl
cluster_name       = "equity-dev-cluster"
region             = "us-west-1"
vpc_id             = "vpc-xxxxxx"

node_group_config = {
  desired_capacity = 2
  min_capacity     = 2
  max_capacity     = 5
  instance_types   = ["t3.medium"]
}
You can also control application scaling via:

yaml
Copy
Edit
# k8s/dev/deployment.yaml
replicas: 2
2. 🏗️ Provision Infrastructure
Go to the Jenkins pipeline: equity-realstate-ops

Select your environment (dev, uat, or prod)

Run the pipeline

This will:

Provision the infrastructure

Install required EKS addons

Prepare the cluster for workloads

3. 🚚 Deploy the Application
Go to the Jenkins pipeline: equity-realstate

Select the same environment (dev, uat, or prod)

Run the pipeline

This will:

Deploy the latest Docker image to EKS

Create a LoadBalancer service

4. 🌐 Configure Domain
After deployment, a LoadBalancer will be created by AWS.

Manually configure a Route53 DNS record to point your domain/subdomain to the LoadBalancer's DNS.

5. 🧹 Destroy Infrastructure
Once you're done testing or deploying:

Go back to the pipeline: equity-realstate-ops

Select the same environment

Enable the DESTROY_INFRA checkbox

Run the pipeline again

This will cleanly destroy all infrastructure except EBS volumes (see below).

⚠️ Manual Cleanup
EBS volumes created by StatefulSets (e.g., MongoDB PVC) must be deleted manually in the AWS Console to avoid leftover storage charges.

✅ Notes
You can control:

Node group instance types and capacity in .tfvars

Application replica count in k8s/dev/deployment.yaml

The pipeline is built for reusability across dev, uat, and prod environments.