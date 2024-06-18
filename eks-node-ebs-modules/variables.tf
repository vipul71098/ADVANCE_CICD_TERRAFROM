variable "environment" {
  description = "Environment suffix to append to resource names"
  type        = string
}

variable "region" {
  description = "Environment suffix to append to resource names"
  type        = string
}


variable "ebs_name" {
  description = "ebs volume size"
  type        = string
  default    =  "*****-ebs"
}



variable "ebs_size" {
  description = "ebs volume size"
  type        = string
  default    =  "100"
}


variable "ebs_type" {
  description = "ebs volume type"
  type        = string
  default    = "io2"
}

variable "ebs_iops" {
  description = "ebs volume iops"
  type        = string
  default     =  "3000"
}


variable "ebs_multi_attach" {
  description = "set ebs multi-attach value to true or false"
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "ebs volume availability zone"
  type        = string
}



variable "nodegroup_name" {
  description = "Environment suffix to append to resource names"
  type        = string
  default     = "*****-nodegroup"
}



variable "node_desired_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
  default     = 1
}





variable "node_max_size" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
  default     = 1
}

variable "node_group_template_name" {
  description = "Name prefix for the launch template of the EKS node group"
  type        = string
  default     = "****nodegroup-launch-template"
}


###### create key pair in ec2 service and use below

variable "key_pair_name" {
  description = "Name of the key pair to use for SSH access to EKS nodes"
  type        = string
  default     = "****-keypair"
}

variable "instance_types" {
  description = "List of EC2 instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.medium"]
}


variable "bucket" {
  description = "The name of the S3 bucket"
  type        = string
}



variable "key_node_ebs" {
  description = "The path to the state file inside the S3 bucket"
  type        = string
}

variable "key_eks_cluster" {
  description = "The path to the state file inside the S3 bucket"
  type        = string
}


###### enter the list of iam users who need access to the nodes


variable "iam_username" {
  description = "The path to the state file inside the S3 bucket"
  type    = list(string)
  default     = ["abc.xyz","xyz.abc"]
}


