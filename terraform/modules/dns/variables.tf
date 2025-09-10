variable "domain_name" {
  description = "Hosted zone domain name"
  type        = string
}

variable "domain_name_acm" {
  description = "Our applications domain name "
  type        = string
}

variable "route53_record_name" {
  description = "Name for the Route 53 record."
  type        = string
}

variable "route53_record_type" {
  description = "Type of the Route 53 record."
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB."
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the ALB."
  type        = string
}
