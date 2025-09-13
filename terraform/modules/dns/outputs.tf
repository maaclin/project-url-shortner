
output "acm_cert" {
  description = "HTTPS ACM certificate"
  value       = aws_acm_certificate.https.arn
}

