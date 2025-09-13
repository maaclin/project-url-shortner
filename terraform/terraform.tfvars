# VPC Variables

vpc_cidr        = "10.0.0.0/16"
azs             = ["eu-west-2a", "eu-west-2b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.4.0/24", "10.0.5.0/24"]

# ALB Variables

# Network Configuration

# ECS Variables

email      = "ysol1046@gmail.com"
ecr_repo   = "projects/url-shortner-repo"
ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

# DNS Variables 

route53_record_name = "ecsv2"
route53_record_type = "A"
domain_name         = "ysolomprojects.co.uk"
domain_name_acm     = "ecsv2.ysolomprojects.co.uk"
