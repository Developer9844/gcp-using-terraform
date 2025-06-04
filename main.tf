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
