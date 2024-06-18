output "node_role_name" {
  value = module.iam.node_role_name
}
output "node_role_arn" {
  value = module.iam.node_role_arn
}


output "eks_cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  value       = module.iam.eks_cluster_role_arn
}


output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "endpoint" {
  value = module.eks_cluster.cluster_name
}

output "certificate_authority" {
  value = module.eks_cluster.certificate_authority
}


output "key_eks_cluster" {
  value = var.key_eks_cluster
}
