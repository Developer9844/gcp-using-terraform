# module "storageBucket" {
#   source = "./modules/storage-bucket"
#   project_name = var.project_name
# }

module "iam_member" {
  source       = "./modules/iam"
  project_id   = var.project_id
  user_account = var.user_account
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}


# module "vm-1" {
#   source              = "./modules/vm"
#   private_subnet_name = module.vpc.private_subnet_name
#   public_subnet_name  = module.vpc.public_subnet_name
#   project_id          = var.project_id
#   project_name        = var.project_name
# }

module "autoscaling" {
  source             = "./modules/autoscaling"
  project_name       = var.project_name
  vpc_name           = module.vpc.vpc_name
  public_subnet_id   = module.vpc.public_subnet_id
  gcp_region_central = var.gcp_region_central
}

module "load_balancer" {
  source                 = "./modules/load-balancer"
  project_name           = var.project_name
  instance_group_manager = module.autoscaling.instance_group_manager
  health_check           = module.autoscaling.health_check
}
