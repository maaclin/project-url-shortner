output "waf_acl_arn" {
  description = "ARN of the regional WAF ACL"
  value       = aws_wafv2_web_acl.alb.arn
}

output "alb_arn" {
  description = "ARN of the regional ALB"
  value       = aws_lb.alb.arn
}