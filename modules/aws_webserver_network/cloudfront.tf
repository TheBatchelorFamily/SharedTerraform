locals {
  cloudfront_origin_domain = var.cloudfront_origin_domain_name != "" ? var.cloudfront_origin_domain_name : try(aws_eip.webserver[0].public_dns, "")
}

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = local.cloudfront_origin_domain
    origin_id   = "webserver-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [
    "www.${var.dnsName}",
    var.dnsName
  ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "webserver-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate_validation.cloudfront.certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  tags = var.tags
}

# ACM certificate for CloudFront (must be in us-east-1)
resource "aws_acm_certificate" "cloudfront" {
  domain_name       = var.dnsName
  provider          = aws.us_east_1
  tags              = var.tags
  validation_method = "DNS"

  subject_alternative_names = [
    "www.${var.dnsName}",
    var.dnsName
  ]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  zone_id = data.aws_route53_zone.website[0].zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cloudfront" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}
