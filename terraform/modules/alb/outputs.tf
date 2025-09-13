output "waf_acl_arn" {
  description = "ARN of the regional WAF ACL"
  value       = aws_wafv2_web_acl.alb.arn
}

output "alb_arn" {
  description = "ARN of the regional ALB"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}
output "blue_tg_name" {
  description = "name of the Blue ALB target group"
  value       = aws_lb_target_group.blue.name
}
output "blue_tg_arn" {
  description = "name of the Blue ALB target group"
  value       = aws_lb_target_group.blue.arn
}

output "green_tg_name" {
  description = "name of the Green ALB target group"
  value       = aws_lb_target_group.green.name
}


output "blue_https_listener" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.https.arn
}

output "green_test_listener" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.green.arn
}

output "alb_zone_id" {
  description = "Zone ID of the ALB."
  value      = aws_lb.alb.zone_id
}