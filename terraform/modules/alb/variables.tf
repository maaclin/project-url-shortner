variable "lb_type" {
  description = "Type of the load balancer."
  type        = string
  default     = "application"
}

variable "ssl_policy" {
  description = "SSL policy for the ALB listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "http_pro" {
  description = "HTTP protocol for the ALB."
  type        = string
  default    = "HTTP"
}

variable "https_pro" {
  description = "HTTPS protocol for the ALB."
  type        = string
  default    = "HTTPS"
}

variable "http" {
  description = "HTTP protocol for the ALB."
  type        = string
  default    = 80
}

variable "https" {
  description = "HTTPS protocol for the ALB."
  type        = string
  default    = 443
}

variable "tcp" {
  description = "TCP protocol for the ALB security group."
  type        = string
  default    = "tcp"
}

variable "alb_sg" {
  description = "Security group ID for the ALB."
  type        = string
}

variable "acm_cert" {
  description = "ACM certificate ARN"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed."
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB."
  type        = list(string)
}
