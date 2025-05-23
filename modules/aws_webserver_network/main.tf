terraform{
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 4.2"
      }
    }
    required_version = "~> 1.2"
}

#This section creates the security group, and opens up ssh and http access.
resource "aws_security_group" "webserver-sg" {
  #ts:skip=AC_AWS_0228 port80OpenToInternet webserver
  name = var.secgroupname
  description = var.secgroupname
  vpc_id = var.vpc

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = var.sshIP
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

#Imports the existing route53 zone name for DNS entry
data "aws_route53_zone" "website" {
  count = var.r53Enabled ? 1:0
  name         = var.dnsName
  private_zone = false
}

resource "aws_eip" "webserver" {
  tags = var.tags
}

resource "aws_route53_record" "www" {
  count = var.r53Enabled ? 1:0
  depends_on = [ aws_eip.webserver ]
  name    = "www.${data.aws_route53_zone.website[0].name}"
  records = [ aws_eip.webserver.public_ip ]
  type    = "A"
  ttl     = "300"
  zone_id = data.aws_route53_zone.website[0].zone_id
}

resource "aws_route53_record" "no_www" {
  count = var.r53Enabled ? 1:0
  depends_on = [ aws_eip.webserver ]
  name    = data.aws_route53_zone.website[0].name
  records = [ aws_eip.webserver.public_ip ]
  type    = "A"
  ttl     = "300"
  zone_id = data.aws_route53_zone.website[0].zone_id
}

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_eip.webserver.public_dns
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
    cloudfront_default_certificate = true
    # For custom domain/SSL, use acm_certificate_arn and set cloudfront_default_certificate = false
  }

  tags = var.tags
}