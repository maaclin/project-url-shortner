
module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}


# module "dns" {
#   source          = "./modules/dns"
#   domain_name     = var.domain_name
#   domain_name_acm = var.domain_name_acm

# }

