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
  name    = "www.${data.aws_route53_zone.website.name}"
  records = [ aws_eip.webserver.public_ip ]
  type    = "A"
  ttl     = "300"
  zone_id = data.aws_route53_zone.website.zone_id
}

resource "aws_route53_record" "no_www" {
  count = var.r53Enabled ? 1:0
  depends_on = [ aws_eip.webserver ]
  name    = data.aws_route53_zone.website.name
  records = [ aws_eip.webserver.public_ip ]
  type    = "A"
  ttl     = "300"
  zone_id = data.aws_route53_zone.website.zone_id
}