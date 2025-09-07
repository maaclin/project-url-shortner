

resource "aws_lb" "alb" {
  name               = "${local.name}-alb"
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  tags = { Name = "${local.name}-alb" }
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.https
  protocol          = var.https_pro
  certificate_arn   = aws_acm_certificate.https.arn
  ssl_policy        = var.ssl_policy

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  depends_on = [aws_lb_target_group.blue]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http
  protocol          = var.http_pro

  default_action {
    type = "redirect"

    redirect {
      port        = var.https
      status_code = "HTTP_301"
      protocol    = var.https_pro
    }
  }
}

resource "aws_lb_target_group" "blue" {
  name        = "${local.name}-tg-blue"
  port        = 8080
  protocol    = var.http_pro
  vpc_id      = aws_vpc.main.id
  target_type = "ip"


  health_check {
    path                = "/healthz"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = { Name = "${local.name}-blue" }
}

resource "aws_lb_target_group" "green" {
  name        = "${local.name}-tg-green"
  port        = 8080
  protocol    = var.http_pro
  vpc_id      = aws_vpc.main.id
  target_type = "ip"


  health_check {
    path                = "/healthz"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
  Name = "${local.name}-green" }
}

resource "aws_lb_listener" "green" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8443
  protocol          = var.https_pro
  certificate_arn   = aws_acm_certificate.https.arn
  ssl_policy        = var.ssl_policy

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  depends_on = [aws_lb_target_group.green]
}


# waf - association to alb 

resource "aws_wafv2_web_acl" "alb" {
  name  = "mywebacl"
  scope = "REGIONAL" # regional for alb

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 0

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "webACLVisibilityConfig"
    sampled_requests_enabled   = true
  }

  tags = {
    Environment = "Production"
    Name        = "webACL"
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.alb.arn
}

output "waf_acl_arn" {
  description = "ARN of the regional WAF ACL"
  value       = aws_wafv2_web_acl.alb.arn
}