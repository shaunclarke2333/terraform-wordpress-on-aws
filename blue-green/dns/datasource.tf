
# Data source for route 53 hosted zone.
data "aws_route53_zone" "shaunsawslabzone" {
  name         = "shaunsawslab.link"
  private_zone = false
}
