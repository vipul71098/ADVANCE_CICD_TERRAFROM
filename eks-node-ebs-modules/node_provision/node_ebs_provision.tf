variable "environment" {
  description = "Environment suffix to append to resource names"
  type        = string
}


variable "cluster_name" {
  description = "Environment suffix to append to resource names"
  type        = string
}

variable "nodegroup_name" {
  description = "Environment suffix to append to resource names"
  type        = string
}


variable "node_role_arn" {
  description = "Environment suffix to append to resource names"
  type        = string
}


variable "node_subnet_ids" {
  description = "Environment suffix to append to resource names"
  type        = list(string)
}

variable "node_desired_size" {
  description = "Environment suffix to append to resource names"
  type        = string
}


variable "node_max_size" {
  description = "Environment suffix to append to resource names"
  type        = string
}

variable "region" {
  description = "Environment suffix to append to resource names"
  type        = string
}


variable "node_min_size" {
  description = "Environment suffix to append to resource names"
  type        = string
}

variable "node_group_template_name" {
  description = "Environment suffix to append to resource names"
  type        = string
}


variable "ebs_volume_id" {
  description = "Environment suffix to append to resource names"
  type        = string
}

variable "key_pair_name" {
  description = "Environment suffix to append to resource names"
  type        = string
}

variable "iam_username" {
  description = "The path to the state file inside the S3 bucket"
  type    = list(string)
}



variable "instance_types" {
  type    = list(string)
}

# EKS Node Group
resource "aws_eks_node_group" "eks_nodegroup" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.nodegroup_name}-${var.environment}"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.node_subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  instance_types = var.instance_types


  ami_type = "AL2_x86_64"

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.eks_nodegroup_template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Launch Template for Node Group with User Data
resource "aws_launch_template" "eks_nodegroup_template" {
  name_prefix = "${var.node_group_template_name}-${var.environment}"
  key_name    = var.key_pair_name
  user_data   = base64encode(<<-EOT
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
MIME-Version: 1.0

--==MYBOUNDARY==
Content-Type: text/cloud-config; charset="us-ascii"
#cloud-config

write_files:
  - path: /tmp/user-data.sh
    permissions: '0755'
    content: |
      #!/bin/bash
      DEVICE=/dev/sdc
      MOUNT_POINT=/data

      # Get the actual device name
      ACTUAL_DEVICE=$(basename $(readlink -f $DEVICE))

      # Function to attach the EBS volume
      attach_volume() {
          INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
          aws ec2 attach-volume --volume-id ${var.ebs_volume_id} --instance-id $INSTANCE_ID --device $DEVICE
          if [ $? -eq 0 ]; then
              echo "$DEVICE attached successfully."
              # Wait for the device to be available
              while [ ! -e "$DEVICE" ]; do sleep 1; done
          else
              echo "Failed to attach $DEVICE."
              exit 1
          fi
      }

      # Attach the EBS volume if it does not exist
      if [ ! -e "$DEVICE" ]; then
          echo "$DEVICE does not exist. Attaching..."
          attach_volume
      else
          echo "$DEVICE exists."
      fi

      # Check if /data is already mounted
      if mountpoint -q $MOUNT_POINT; then
          echo "$MOUNT_POINT is already mounted."
      else
          # Create mount point directory if it doesn't exist
          mkdir -p $MOUNT_POINT

          # Check if the device has an existing filesystem
          FSTYPE=$(lsblk -no FSTYPE /dev/$ACTUAL_DEVICE)
          if [ -z "$FSTYPE" ]; then
              echo "Creating filesystem on /dev/$ACTUAL_DEVICE."
              mkfs -t xfs /dev/$ACTUAL_DEVICE
          else
              echo "/dev/$ACTUAL_DEVICE already has a filesystem: $FSTYPE."
          fi

          # Mount the device
          mount /dev/$ACTUAL_DEVICE $MOUNT_POINT

          if [ $? -eq 0 ]; then
              echo "/dev/$ACTUAL_DEVICE mounted successfully on $MOUNT_POINT."
          else
              echo "Failed to mount /dev/$ACTUAL_DEVICE on $MOUNT_POINT."
              exit 1
          fi

          # Ensure the device mounts on reboot
          if ! grep -qs "$DEVICE" /etc/fstab; then
              echo "/dev/$ACTUAL_DEVICE $MOUNT_POINT xfs defaults,nofail 0 2" >> /etc/fstab
          fi

      fi
      mkdir -p /data/backup-eta-sp-csv /data/backup-pkl /data/client-maps /data/global /data/global/pbf_static

runcmd:
  - /tmp/user-data.sh


--==MYBOUNDARY==--
EOT
  )
}







data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name

}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.certificate_authority)
  token                  = data.aws_eks_cluster_auth.this.token
}



resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}
      sudo -u ubuntu -i aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}


      map_users=""
      for user_name in ${join(" ", formatlist("'%s'", var.iam_username))}; do
        user_arn=$(aws iam get-user --user-name "$user_name" --query 'User.Arn' --output text || echo "")
        if [ -n "$user_arn" ]; then
          if [ -z "$map_users" ]; then
            map_users="- userarn: $user_arn\n  username: $user_name\n  groups:\n    - system:masters"
          else
            map_users="$map_users\n- userarn: $user_arn\n  username: $user_name\n  groups:\n    - system:masters"
          fi
        else
          echo "Skipping user '$user_name' as the IAM user does not exist."
        fi
      done

      kubectl -n kube-system patch configmap/aws-auth --type=merge -p "{
        \"data\": {
          \"mapUsers\": \"$map_users\"
        }
      }"
    EOT

    environment = {
      AWS_DEFAULT_REGION = var.region
    }

    on_failure = continue
  }

  triggers = {
    always_run = timestamp()
  }

depends_on = [aws_eks_node_group.eks_nodegroup]
}

