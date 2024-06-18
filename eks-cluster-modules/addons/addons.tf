variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}


# Create a null resource to check if the addon is installed
resource "null_resource" "check_ebs_csi_addon" {
  provisioner "local-exec" {
    command = <<EOT
    if aws eks describe-addon --cluster-name ${var.cluster_name} --addon-name aws-ebs-csi-driver > /dev/null 2>&1; then
      echo "EBS CSI Addon already exists"
    else
      aws eks create-addon --cluster-name ${var.cluster_name} --addon-name aws-ebs-csi-driver --resolve-conflicts OVERWRITE
    fi
    EOT
  }
}


# Reinstall EKS Addon for EBS CSI Driver only if it's not already installed
resource "null_resource" "reinstall_ebs_csi_addon" {
  depends_on = [
    null_resource.check_ebs_csi_addon,
  ]

  provisioner "local-exec" {
    command = <<EOT
    if ! aws eks describe-addon --cluster-name ${var.cluster_name} --addon-name aws-ebs-csi-driver > /dev/null 2>&1; then
      aws eks create-addon --cluster-name ${var.cluster_name} --addon-name aws-ebs-csi-driver --resolve-conflicts OVERWRITE
    fi
    EOT
  }
}
