resource "aws_iam_group" "admin_group" {
  name = "Admins"
}

resource "aws_iam_group_membership" "admin_team" {
  name = "Admins"

  users = [
    aws_iam_user.terraform_user.name,
    aws_iam_user.chris_user.name,
  ]

  group = aws_iam_group.admin_group.name
}

resource "aws_iam_group_policy" "admin_policy" {
  name  = "admin_policy"
  group = aws_iam_group.admin_group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = templatefile("",
{
  variable = "${path.module}/resources/AdminGroupPolicy.tftpl"
})
}
