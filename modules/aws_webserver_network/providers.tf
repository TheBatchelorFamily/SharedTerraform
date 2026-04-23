terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.us_east_1]
      source                = "hashicorp/aws"
      version               = "~> 5.98"
    }
  }
  required_version = "~> 1.12"
}
