variable "region" {
  description = "Name of the IAM role for the cluster"
  type        = string
}


variable "environment" {
  description = "Name of the IAM role for the cluster"
  type        = string
}

variable "subnet_ids" {
  description = "ID of the subnet where resources will be deployed"
  type        = list(string)
}



variable "acm_arn" {
  description = "ID of the subnet where resources will be deployed"
  type        =  string
  default    =  "arn:aws:acm:ap-south-1:*********:certificate/*********"
}


variable "key_eks_cluster" {
  description = "The path to the state file inside the S3 bucket"
  type        = string
}

variable "bucket" {
  description = "The path to the state file inside the S3 bucket"
  type        = string
}


variable "alb_name" {
  description = "The path to the state file inside the S3 bucket"
  type        = string
  default     = "******-alb"
}

