resource "aws_route53_record" "live_environment" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = var.record_type
  ttl     = var.cname_ttl

  records = var.cname_records
}
