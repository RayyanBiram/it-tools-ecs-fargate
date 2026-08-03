output "certificate_arn" {
  description = "ARN of the certificate"
  value       = aws_acm_certificate_validation.cert.certificate_arn
}