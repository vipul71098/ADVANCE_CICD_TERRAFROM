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
    key            = var.key_node_ebs
    region         = var.region
  }
}



module "git-pull" {
  source = "./modules/git-pull"
  repo_urls = var.repo_urls
  repo_branches = var.repo_branches
}


module "docker-build" {
  source = "./modules/docker-build"

  image_names = var.image_names
  repo_directories = module.git-pull.repo_directories
  ecr_repository_urls = module.ecr-repo.ecr_repository_urls
}

module "ecr-repo" {
  source = "./modules/ecr-repo"
  #image_names = var.image_names-var.environment
  image_names = [for name in var.image_names : "${name}-${var.environment}"]
}


module "docker-push" {
  source = "./modules/docker-push"
  image_names = var.image_names
  repo_directories = module.git-pull.repo_directories
  ecr_repository_urls = module.ecr-repo.ecr_repository_urls
  aws_region =  var.region
  depends_on = [module.docker-build, module.ecr-repo]
}

module "k8s-deploy" {
  source = "./modules/k8s_deployment"
  ecr_repository_urls = module.ecr-repo.ecr_repository_urls
  repo_directories = module.git-pull.repo_directories
  ebs_volume_id = data.terraform_remote_state.eks.outputs.ebs_volume_id
  ebs_volume_size = data.terraform_remote_state.eks.outputs.ebs_size
  ebs_volume_type = data.terraform_remote_state.eks.outputs.ebs_type

  depends_on = [module.docker-build, module.ecr-repo, module.docker-push]
}

