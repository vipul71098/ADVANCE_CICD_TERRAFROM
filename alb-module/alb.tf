
provider "aws" {
  region =  var.region
}


 provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.eks.outputs.cluster_name

}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.certificate_authority)
  token                  = data.aws_eks_cluster_auth.this.token
}



terraform {
  backend "s3" {}
}


data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket         = var.bucket
    key            = var.key_eks_cluster
    region         = var.region
  }
}





resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller-${var.environment}"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.4.0"
  namespace  = "default"


  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }

  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }

  set {
    name  = "clusterName"
    value = data.terraform_remote_state.eks.outputs.cluster_name
  }
}





resource "null_resource" "ingress_apply" {
    triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      set -e

      sed -i 's|SUBNET_ID|${var.subnet_ids[0]},${var.subnet_ids[1]}|g' ingress.yml
      sed -i 's|ACM_ARN|${var.acm_arn}|g' ingress.yml
      sed -i 's|ALB_NAME|${var.alb_name}-${var.environment}|g' ingress.yml

          
      # Apply Kubernetes manifest
      kubectl apply -f  ingress.yml
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}



