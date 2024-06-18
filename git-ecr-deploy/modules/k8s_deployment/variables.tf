variable "repo_directories" {
  description = "Directories of the cloned Git repositories"
  type        = list(string)
}

variable "ecr_repository_urls" {
  description = "URLs of the created ECR repositories"
  type        = list(string)
}



variable "ebs_volume_id" {
  description = "URLs of the created ECR repositories"
  type        = string
}


variable "ebs_volume_size" {
  description = "URLs of the created ECR repositories"
  type        = string
}


variable "ebs_volume_type" {
  description = "URLs of the created ECR repositories"
  type        = string
}


