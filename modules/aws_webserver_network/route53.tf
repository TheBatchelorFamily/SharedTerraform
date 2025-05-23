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