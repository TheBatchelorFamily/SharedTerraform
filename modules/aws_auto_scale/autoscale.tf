#This section grabs the latest ami image for Amazon Linux 2023
#Keeps patches current at each deployment.
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-hvm-*-x86_64-ebs"]
  }
}

# Get the security group to determine the VPC
data "aws_security_group" "webserver" {
  id = var.securityGroup[0]
}

# Get all subnets in the VPC for multi-AZ deployment
data "aws_subnets" "webserver" {
  filter {
    name   = "vpc-id"
    values = [data.aws_security_group.webserver.vpc_id]
  }
}

resource "aws_key_pair" "webserver" {
  key_name   = var.keyname
  public_key = var.sshPub
  tags       = var.tags
}

resource "aws_launch_template" "aws_autoscale_templ" {
  image_id               = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.iType
  key_name               = var.keyname
  name                   = "web_server_scale"
  tags                   = var.tags
  user_data              = var.userData
  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.web_server_profile.name
  }

  instance_market_options {
    market_type = "spot"
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interfaces {
    associate_public_ip_address = var.publicIP
    delete_on_termination       = true
    security_groups             = var.securityGroup
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
}

resource "aws_autoscaling_group" "mygroup" {
  force_delete         = true
  max_size             = 1
  min_size             = 1
  name                 = "WebServerASG"
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = data.aws_subnets.webserver.ids

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  instance_refresh {
    strategy = "Rolling"
  }

  launch_template {
    id      = aws_launch_template.aws_autoscale_templ.id
    version = aws_launch_template.aws_autoscale_templ.latest_version
  }
}
