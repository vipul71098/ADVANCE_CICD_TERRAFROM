resource "aws_ecr_repository" "repos" {
  count = length(var.image_names)
  name  = var.image_names[count.index]
}

resource "aws_ecr_repository_policy" "repo_policies" {
  count      = length(var.image_names)
  repository = aws_ecr_repository.repos[count.index].name
  policy     = <<-EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "ECRRepositoryPolicy",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  }
  EOF
}

