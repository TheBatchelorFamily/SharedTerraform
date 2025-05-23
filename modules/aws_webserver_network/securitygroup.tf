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
