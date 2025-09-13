
module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "sgroups" {
  source          = "./modules/sgroups"
  vpc_id          = module.vpc.vpc_id
  vpc_cidr        = module.vpc.vpc_cidr
  private_subnets = module.vpc.private_subnet_ids
  private_rt      = module.vpc.private_rt
}

module "ecr" {
  source   = "./modules/ecr"
  ecr_repo = var.ecr_repo
}

module "iam" {
  source     = "./modules/iam"
  table_name = module.ecs.table_name
  ecr_repo   = module.ecr.ecr_repo
}

module "dns" {
  source              = "./modules/dns"
  domain_name         = var.domain_name
  domain_name_acm     = var.domain_name_acm
  route53_record_name = var.route53_record_name
  route53_record_type = var.route53_record_type
  alb_dns_name        = module.alb.alb_dns_name
  alb_zone_id         = module.alb.alb_zone_id
}

module "ecs" {
  source          = "./modules/ecs"
  email           = var.email
  private_subnets = module.vpc.private_subnet_ids
  ecs_sg          = module.sgroups.ecs_sg
  blue_tg         = module.alb.blue_tg_name
  blue_tg_arn     = module.alb.blue_tg_arn
  blue_listener   = module.alb.blue_https_listener
  execution_role  = module.iam.execution_role
  task_role       = module.iam.task_role
  ecr_repo        = module.ecr.ecr_repo
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_sg         = module.sgroups.alb_sg
  ssl_policy     = var.ssl_policy
  acm_cert       = module.dns.acm_cert
}

module "codedeploy" {
  source              = "./modules/codedeploy"
  codedeploy_role     = module.iam.codedeploy_role
  cluster_name        = module.ecs.cluster_name
  ecs_service         = module.ecs.ecs_service
  blue_https_listener = module.alb.blue_https_listener
  blue_tg_name             = module.alb.blue_tg_name
  green_tg_name            = module.alb.green_tg_name
  green_test_listener = module.alb.green_test_listener
}
