variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of the Kubernetes cluster"
  type        = string
}

variable "subnet_ids" {
  description = "ID of the subnet where resources will be deployed"
  type        = list(string)
}


variable "eks_cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'dev', 'prod')"
  type        = string
}


resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.cluster_name}-${var.environment}"
  role_arn = var.eks_cluster_role_arn
  version  = "${var.cluster_version}"

  vpc_config {
    subnet_ids = var.subnet_ids
  }

}



output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "certificate_authority" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

