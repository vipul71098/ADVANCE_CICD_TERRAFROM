variable "region" {
  description = "Name of the AWS region"
  type        = string
}


variable "environment" {
  description = "Environment name (e.g., 'dev', 'prod')"
  type        = string
}



variable "repo_urls" {
  description = "List of Git repository URLs"
  type        = list(string)
}

variable "repo_branches" {
  description = "List of Git repository branches to pull"
  type        = list(string)
}

variable "image_names" {
  description = "Names of the Docker images"
  type        = list(string)
}


variable "bucket" {
  description = "The name of the S3 bucket"
  type        = string
}



variable "key_node_ebs" {
  description = "The path to the state file inside the S3 bucket"
  type        = string
}


