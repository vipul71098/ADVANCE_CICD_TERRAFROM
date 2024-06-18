# Module to create the EBS volume

variable "environment" {
  description = "Environment suffix to append to resource names"
  type        = string
}

variable "ebs_name" {
  description = "ebs volume size"
  type        = string
}



variable "ebs_size" {
  description = "ebs volume size"
  type        = string
}


variable "ebs_type" {
  description = "ebs volume type"
  type        = string
}

variable "ebs_iops" {
  description = "ebs volume iops"
  type        = string
}


variable "ebs_multi_attach" {
  description = "set ebs multi-attach value to true or false"
  type        = bool
}

variable "availability_zone" {
  description = "ebs volume availability zone"
  type        = string
}



resource "aws_ebs_volume" "node_volume" {
  availability_zone     = var.availability_zone
  size                  = var.ebs_size
  type                  = var.ebs_type
  iops                  = var.ebs_iops
  multi_attach_enabled  = var.ebs_multi_attach
  tags = {
    Name = "${var.ebs_name}-${var.environment}"
  }
}




resource "null_resource" "wait_for_volume" {
  provisioner "local-exec" {
    command = <<-EOT
      aws ec2 wait volume-available --volume-ids ${aws_ebs_volume.node_volume.id}
    EOT
  }

  depends_on = [
    aws_ebs_volume.node_volume
  ]
}
