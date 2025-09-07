

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.route53_record_name
  type    = var.route53_record_type

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "https" {
  domain_name       = var.domain_name_acm
  validation_method = var.validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_valid" {
  zone_id         = data.aws_route53_zone.main.zone_id
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.acm_ttl
  type            = each.value.type

  for_each = {
    for dvo in aws_acm_certificate.https.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
}

resource "aws_acm_certificate_validation" "valid" {
  certificate_arn         = aws_acm_certificate.https.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_valid : record.fqdn]

}