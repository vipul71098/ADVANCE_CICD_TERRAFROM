variable "image_names" {
  description = "Names of the Docker images"
  type        = list(string)
}

variable "repo_directories" {
  description = "Directories of the cloned Git repositories"
  type        = list(string)
}

variable "ecr_repository_urls" {
  description = "URLs of the created ECR repositories"
  type        = list(string)
}

