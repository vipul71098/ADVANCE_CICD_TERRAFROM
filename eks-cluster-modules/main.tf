

provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {}
}

module "iam" {
  source = "./iam"
  cluster_role_name = var.cluster_role_name
  node_role_name = var.node_role_name
  alb_node_role_name = var.alb_node_role_name
  attach_volume_policy_name = var.attach_volume_policy_name
  environment = var.environment
}



module "eks_cluster" {
  source = "./cluster"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids = var.subnet_ids
  environment = var.environment
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn

 depends_on = [ module.iam  ]

}

module "eks_addons" {
  source = "./addons"
  cluster_name = module.eks_cluster.cluster_name

 depends_on = [ module.eks_cluster ]
}

