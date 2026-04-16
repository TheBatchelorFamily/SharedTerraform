#Imports the existing route53 zone name for DNS entry
data "aws_route53_zone" "website" {
  count        = var.r53Enabled ? 1 : 0
  name         = var.dnsName
  private_zone = false
}

# checkov:skip=CKV2_AWS_19: EIP is associated by user_data
resource "aws_eip" "webserver" {
  tags = var.tags
}

# Add/replace these records to point to CloudFront instead of the EIP

resource "aws_route53_record" "www" {
  count = var.r53Enabled ? 1 : 0
  name  = "www.${data.aws_route53_zone.website[0].name}"
  type  = "A"
  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
  zone_id = data.aws_route53_zone.website[0].zone_id
}

resource "aws_route53_record" "no_www" {
  count = var.r53Enabled ? 1 : 0
  name  = data.aws_route53_zone.website[0].name
  type  = "A"
  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
  zone_id = data.aws_route53_zone.website[0].zone_id
}