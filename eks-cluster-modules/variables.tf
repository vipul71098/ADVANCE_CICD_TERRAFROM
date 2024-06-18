variable "region" {
  description = "Name of the IAM role for the cluster"
  type        = string
}


variable "cluster_role_name" {
  description = "Name of the IAM role for the cluster"
  type        = string
  default    = "****-cluster-role"
}

variable "node_role_name" {
  description = "Name of the IAM role for nodes"
  type        = string
  default     = "*****-node-role"
}

variable "attach_volume_policy_name" {
  description = "Name of the IAM policy for attaching volumes"
  type        = string
  default     = "*****-attch-volume-policy"
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "*****-eks-cluster"
}

variable "cluster_version" {
  description = "Version of the Kubernetes cluster"
  type        = string
  default     = "1.30"
}

variable "vpc_id" {
  description = "ID of the VPC where resources will be deployed"
  type        = string
}


variable "subnet_ids" {
  description = "ID of the subnet where resources will be deployed"
  type        = list(string)
}


variable "environment" {
  description = "Environment name (e.g., 'dev', 'prod')"
  type        = string
}



variable "alb_node_role_name" {
  description = "Name of the IAM policy for attaching volumes"
  type        = string
  default    = "*****-node-role"
}



variable "key_eks_cluster" {
  description = "The path to the state file inside the S3 bucket"
  type        = string
}
