# VPC Variables

vpc_cidr        = "10.0.0.0/16"
azs             = ["eu-west-2a", "eu-west-2b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.4.0/24", "10.0.5.0/24"]
name            = "ecs-v2"

# # ALB Variables

# http      = "80"
# https     = "443"
# tcp       = "tcp"
# http_pro  = "HTTP"
# https_pro = "HTTPS"
# allow     = "0.0.0.0/0"

# # ECS Variables


# lb_type       = "application"
# ssl_policy    = "ELBSecurityPolicy-TLS13-1-2-2021-06"
# ecs_cpu       = "256"
# ecs_memory    = "512"
# email_address = "ysol1046@gmail.com"

# # DNS Variables 

# route53_record_name = "ecsv2"
# route53_record_type = "A"
# domain_name         = "ysolomprojects.co.uk"
# domain_name_acm     = "ecsv2.ysolomprojects.co.uk"

# # DynamoDB Variables

# table_name = "ecs-v2"   