#This section creates the security group, and opens up ssh and http access.

resource "aws_security_group" "webserver-sg" {
  #ts:skip=AC_AWS_0228 port80OpenToInternet webserver
  # checkov:skip=CKV2_AWS_5:Security group is attached at the root module level
  # checkov:skip=CKV_AWS_382 CKV_AWS_260: This is a web server

  name        = var.secgroupname
  description = var.secgroupname
  vpc_id      = var.vpc

  // To Allow SSH Transport
  ingress {
    description = "Allow SSH from specific IP"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = var.sshIP
  }

  // To Allow Port 80 Transport
  ingress {
    # checkov:skip=CKV_AWS_382 CKV_AWS_260: This is a web server
    description = "Allow HTTP from anywhere"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
