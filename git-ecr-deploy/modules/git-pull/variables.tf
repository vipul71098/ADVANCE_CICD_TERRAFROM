variable "repo_urls" {
  description = "List of Git repository URLs"
  type        = list(string)
}

variable "repo_branches" {
  description = "List of Git repository branches to pull"
  type        = list(string)
}
