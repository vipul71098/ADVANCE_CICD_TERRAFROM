
resource "null_resource" "apply_k8s_manifests" {
  count = length(var.repo_directories)

  triggers = {
    repo_dir = "${var.repo_directories[count.index]}/build"
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      set -e

      sed -i 's|<<ECR-LINK>>|${var.ecr_repository_urls[0]}:latest|g' ${self.triggers.repo_dir}/deployment.yml
      sed -i 's|STORAGE_SIZE|${var.ebs_volume_size}|g' ${self.triggers.repo_dir}/persistent-volume.yml
      sed -i 's|VOLUME_ID|${var.ebs_volume_id}|g' ${self.triggers.repo_dir}/persistent-volume.yml
      sed -i 's|STORAGE_CLASS_TYPE|${var.ebs_volume_type}|g' ${self.triggers.repo_dir}/persistent-volume.yml
     
      # Apply Kubernetes manifest
      kubectl apply -f ${self.triggers.repo_dir}
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

