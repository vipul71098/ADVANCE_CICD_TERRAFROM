resource "null_resource" "push_docker_image" {
  count = length(var.image_names)
  triggers = {
    image_name      = var.image_names[count.index]
    repo_dir        = var.repo_directories[count.index]
    repository_url  = var.ecr_repository_urls[count.index]
  }

  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      set -e
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${self.triggers.repository_url}
      docker push ${self.triggers.repository_url}:latest
    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "docker logout ${self.triggers.repository_url}"
    interpreter = ["/bin/bash", "-c"]
  }
}

