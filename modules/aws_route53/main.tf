provider "aws" {
  region = var.region
}

#Imports the existing route53 zone name for DNS entry
data "aws_route53_zone" "website" {
  name         = var.dnsName
  private_zone = false
}

resource "aws_eip" "webserver" {
  instance = var.spot_instance_id
  vpc      = true
  tags = var.tags
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.website.zone_id
  name    = "www.${data.aws_route53_zone.website.name}"
  type    = "A"
  ttl     = "300"
  records = [ aws_eip.webserver.public_ip ]

  depends_on = [ aws_eip.webserver ]
}

resource "aws_route53_record" "no_www" {
  zone_id = data.aws_route53_zone.website.zone_id
  name    = data.aws_route53_zone.website.name
  type    = "A"
  ttl     = "300"
  records = [ aws_eip.webserver.public_ip ]

  depends_on = [ aws_eip.webserver ]
}