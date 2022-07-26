terraform{
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 4.2"
      }
    }
    required_version = "~> 1.2"
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

resource "aws_key_pair" "webserver" {
  key_name   = var.keyname
  public_key = var.sshPub
  tags = var.tags
}

resource "aws_launch_template" "aws_autoscale_templ" {
  image_id                    = data.aws_ami.amazon_linux_2.id
  instance_market_options {
    market_type = "spot"
  }
  instance_type               = var.iType
  key_name                    = var.keyname
  lifecycle {
    create_before_destroy     = true
  }
  name                        = "web_server_scale"
  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = var.securityGroup
    subnet_id                   = var.subnet
  }
  tags                        = var.tags
  user_data                   = var.userData
}

resource "aws_autoscaling_group" "mygroup" {
  force_delete              = true
  launch_template {
    id      = aws_launch_template.aws_autoscale_templ.id
    version                 = aws_launch_template.aws_autoscale_templ.latest_version
  }
  max_size                  = 2
  min_size                  = 1
  name                      = "WebServerASG"
  termination_policies      = ["OldestInstance"]
}