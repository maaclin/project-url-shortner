variable "lb_type" {
  description = "Type of the load balancer."
  type        = string
}

variable "ssl_policy" {
  description = "SSL policy for the ALB listener."
  type        = string
}

variable "http_pro" {
  description = "HTTP protocol for the ALB."
  type        = string
}

variable "https_pro" {
  description = "HTTPS protocol for the ALB."
  type        = string
}

variable "http" {
  description = "HTTP protocol for the ALB."
  type        = string
}

variable "https" {
  description = "HTTPS protocol for the ALB."
  type        = string
}

variable "tcp" {
  description = "TCP protocol for the ALB security group."
  type        = string
}

locals {
  name   = "ecs-v2" 
}