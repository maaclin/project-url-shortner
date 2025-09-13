variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

# Network Configuration

variable "ecr_repo" {
  description = "ECR repository name"
  type        = string
}

# ALB Configuration


variable "ssl_policy" {
  description = "SSL policy for the ALB listener"
  type        = string
}

# ECS Configuration


# ACM Configuration


variable "domain_name" {
  description = "Hosted zone domain name"
  type        = string
  default     = ""
}

variable "domain_name_acm" {
  description = "Domain name for ACM certificate"
  type        = string
  default     = ""
}

variable "route53_record_name" {
  description = "Name for the Route 53 record"
  type        = string
  default     = ""
}

variable "route53_record_type" {
  description = "Type of the Route 53 record"
  type        = string
  default     = "A"
}

# Monitoring

variable "email" {
  description = "Email address for alerts"
  type        = string
}