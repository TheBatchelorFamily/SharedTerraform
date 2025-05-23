data "aws_iam_policy_document" "assign-eip" {
  statement {
    actions = [
      "ec2:DescribeAddresses",
      "ec2:AllocateAddress",
      "ec2:DescribeInstances",
      "ec2:AssociateAddress"
    ]
    resources = [
      "arn:aws:ec2:*"
    ]
  }
}

data "aws_iam_policy_document" "assume-role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
  name               = var.iamRoleName
  tags               = var.tags
}

resource "aws_iam_role_policy" "assign_eip_policy" {
  name   = var.iamRoleName
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.assign-eip.json
}

resource "aws_iam_instance_profile" "web_server_profile" {
  name = var.iamRoleName
  role = aws_iam_role.role.name
}