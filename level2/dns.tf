# DNS simple routing alias record for elb friendly name
module "elb_friendly_name" {
  source                 = "../modules/route53"
  zone_id                = data.aws_route53_zone.shaunsawslabzone.id
  record_name            = "loadbalancer"
  record_type            = "A"
  alias_name             = module.main-elb.lb_dns_name
  alias_zone_id          = module.main-elb.lb_zone_id
  evaluate_target_health = true

  # Creating aws ssl certificate
  domain_name          = "loadbalancer.shaunsawslab.link"
  validation_method    = "DNS"
  certificate_tag_name = "main-ssl"

  # domain validation option record
  validation_zone_id = data.aws_route53_zone.shaunsawslabzone.id
}
