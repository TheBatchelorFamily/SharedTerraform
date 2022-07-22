provider "aws" {
  region = var.region
}

#This section grabs the latest ami image for Amazon Linux
#Keeps patches current at each deployment.
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
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

resource "aws_key_pair" "webserver" {
  key_name   = var.keyname
  public_key = var.sshPub
  tags = var.tags
}

resource "aws_spot_instance_request" "webserver" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = var.iType
  subnet_id = var.subnet
  associate_public_ip_address = false
  key_name = var.keyname
  wait_for_fulfillment = true
  user_data = var.userData

  vpc_security_group_ids = [
    aws_security_group.webserver-sg.id
  ]
  
  root_block_device {
    delete_on_termination = true
    volume_size = 15
  }
  tags = var.tags

  depends_on = [ aws_security_group.webserver-sg ]
}
