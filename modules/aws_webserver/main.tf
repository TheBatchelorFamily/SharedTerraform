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
