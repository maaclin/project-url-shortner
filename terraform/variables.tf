
# ## VPC Configuration Variables


variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "name" {
  description = "HTTP port."
  type        = number
}

variable "public_subnets" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnets" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "azs" {
  type = list(string)
}

# ## dns

# variable "domain_name" {
#   description = "Domain name"
#   type        = string
# }

# variable "domain_name_acm" {
#   description = "Domain name"
#   type        = string
# }

# variable "route53_record_name" {
#   description = "Name for the Route 53 record."
#   type        = string
# }


# variable "alb_dns_name" {
#   description = "DNS name of the ALB."
#   type        = string
# }

# variable "alb_zone_id" {
#   description = "Zone ID of the ALB."
#   type        = string
# }

# # ## alb

# variable "lb_type" {
#   description = "Type of the load balancer."
#   type        = string
# }

# variable "ssl_policy" {
#   description = "SSL policy for the ALB listener."
#   type        = string
# }

# variable "http_pro" {
#   description = "HTTP protocol for the ALB."
#   type        = string
# }

# variable "https_pro" {
#   description = "HTTPS protocol for the ALB."
#   type        = string
# }

# variable "tcp" {
#   description = "TCP protocol for the ALB security group."
#   type        = string
# }

# variable "allow" {
#   description = "CIDR blocks allowed for ALB security group."
#   type        = string
# }

# # variable "vpc_id" {
# #   description = "VPC ID"
# #   type        = string
# # }

# # variable "subnet_ids" {
# #   description = "Subnet IDs for ALB"
# #   type        = list(string)
# # }

# # variable "acm_certificate_arn" {
# #   description = "ARN of the SSL certificate for the ALB."
# #   type        = string
# # }


# # # ECS Variables

# # variable "ecr_uri" {
# #   type = string
# # }
# # variable "app_dname" {
# #   description = "Domain name for the application."
# #   type        = string
# # }
# variable "ecs_cpu" {
#   description = "CPU units for the ECS task."
#   type        = number
# }
# variable "ecs_memory" {
#   description = "Memory in MiB for the ECS task."
#   type        = number
# }

# # variable "http" {
# #   description = "HTTP port."
# #   type        = number
# # }

# # variable "destination_cidr" {
# #   description = "The destination CIDR block for the public route."
# #   type        = string
# # }

# # variable "ecs_sg" {
# #   description = "Name of the security group."
# #   type        = string
# # }

# # variable "https" {
# #   description = "HTTPS port."
# #   type        = number
# # }

# # variable "protocol" {
# #   description = "Protocol for the security group."
# #   type        = string
# # }

# # variable "vpc_id" {
# #   description = "VPC ID"
# #   type        = string
# # }

# # variable "subnet_ids" {
# #   description = "Subnet IDs"
# #   type        = list(string)
# # }

# # variable "alb_security_group_id" {
# #   description = "ALB Security Group ID"
# #   type        = string
# # }

# # variable "iam_role_arn" {
# #   description = "ECS Task Execution Role ARN"
# #   type        = string
# # }

# # variable "alb_target_group_arn" {
# #   description = "Name of the ALB target group."
# #   type        = string
# # }

# # variable "alb_listener_arn" {
# #   description = "ARN of the ALB listener."
# #   type        = string
# # }

# # ## acm 

# variable "domain_name_acm" {
#   description = "Domain name for the ACM certificate."
#   type        = string
# }

# variable "validation_method" {
#   description = "Validation method for the ACM certificate."
#   type        = string
# }

# # variable "acm_ttl" {
# #   description = "TTL for the ACM certificate validation record."
# #   type        = number
# # }

# # variable "domain_name" {
# #   description = "Domain name for Route 53."
# #   type        = string
# # }

# # ## iam 

# variable "email_address" {
#   type = string
# }
# # variable "ecs_task_execution_role" {
# #   description = "ARN of the ECS task execution role."
# #   type        = string
# # }
# # variable "ecs_task_role_policy_arn" {
# #   description = "ARN of the ECS task role policy."
# #   type        = string
# # }

# # variable "year_version" {
# #   description = "Version of the policy."
# #   type        = string
# # }

# # variable "policy_action" {
# #   description = "Action for the IAM policy."
# #   type        = string
# # }

# # variable "policy_effect" {
# #   description = "Effect of the IAM policy."
# #   type        = string
# # }

# # variable "policy_principal" {
# #   description = "Principal for the IAM policy."
# #   type        = string
# # }

# # variable "ecs_cluster_name" {
# #   description = "The name of the ECS cluster."
# #   type        = string
# # }

# # dyanamodb 

# variable "table_name" {
#   description = "The name of the DynamoDB table."
#   type        = string
# }