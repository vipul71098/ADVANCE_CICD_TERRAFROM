provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {}
}





data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket         = var.bucket
    key            = var.key_eks_cluster
    region         = var.region
  }
}



data "aws_subnet" "az_subnet" {
  filter {
    name   = "availability-zone"
    values = ["${var.availability_zone}"]
  }
}

module "ebs_volume" {
  source = "./ebs"

  availability_zone     = var.availability_zone
  ebs_size              = var.ebs_size
  ebs_type              = var.ebs_type
  ebs_iops              = var.ebs_iops
  ebs_multi_attach      = var.ebs_multi_attach
  ebs_name              = var.ebs_name
  environment           = var.environment
}


module "node_ebs_provision" {
  source = "./node_provision"

  cluster_name    = data.terraform_remote_state.eks.outputs.cluster_name
  node_role_arn   = data.terraform_remote_state.eks.outputs.node_role_arn
  node_subnet_ids     = [data.aws_subnet.az_subnet.id]
  environment         = var.environment
  region              = var.region
  nodegroup_name      = var.nodegroup_name
  node_desired_size   = var.node_desired_size
  node_max_size       = var.node_max_size
  node_min_size       = var.node_min_size
  node_group_template_name = var.node_group_template_name
  key_pair_name       = var.key_pair_name
  instance_types      = var.instance_types
  ebs_volume_id      = module.ebs_volume.volume_id
  iam_username       =  var.iam_username
  

}




