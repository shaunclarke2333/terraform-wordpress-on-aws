output "acm_certificate_output" {
  description = "This output contains the attribute details for the aws_acm_certificate_validation reasource"
  value       = aws_acm_certificate_validation.cert_validation
}

output "domain_name" {
  description = "This output contains the domain name"
  value       = aws_acm_certificate.certificate.domain_name
}
