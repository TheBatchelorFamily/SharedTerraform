terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.98"
    }
  }
  required_version = "~> 1.12"
}

provider "aws" {
  alias = "us_east_1"
}
