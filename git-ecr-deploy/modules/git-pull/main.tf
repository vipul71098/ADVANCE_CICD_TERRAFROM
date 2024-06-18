resource "null_resource" "git_pull" {
  count = length(var.repo_urls)

  triggers = {
    repo_url = var.repo_urls[count.index]
    repo_branch = var.repo_branches[count.index]
    repo_dir = "${path.module}/repos/${basename(var.repo_urls[count.index])}"
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      set -e
      if [ -d "${self.triggers.repo_dir}" ]; then
        echo "Deleting existing directory: ${self.triggers.repo_dir}"
        rm -rf "${self.triggers.repo_dir}"
      fi
      git clone --branch ${self.triggers.repo_branch} ${self.triggers.repo_url} "${self.triggers.repo_dir}"
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

