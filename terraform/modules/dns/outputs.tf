
output "acm_https" {
  description = "HTTPS ACM certificate"
  value       = aws_acm_certificate.https.arn
}