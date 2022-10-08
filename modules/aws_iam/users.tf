resource "aws_iam_user" "terraform_user" {
  name = "Terraform"
}

resource "aws_iam_user" "chris_user" {
  name = "Chris"
}
