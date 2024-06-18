
resource "null_resource" "build_docker_image" {
  count = length(var.image_names)
  triggers = {
    image_name        = var.image_names[count.index]
    repo_dir          = "${var.repo_directories[count.index]}/build"
    ecr_repository_url = var.ecr_repository_urls[count.index]
  }

  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      set -e
      docker build -t ${self.triggers.ecr_repository_url}:latest -f ${self.triggers.repo_dir}/Dockerfile ${var.repo_directories[count.index]}
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

