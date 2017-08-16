terraform {
  required_version = ">= 0.9.0"

  backend "s3" {
  }
}

# The reference architecture assumes the bootstrap network lives in the AWS Production account
# and credentials set in the ENV
provider "aws" {
  region = "${var.bootstrap-aws-default-region}"
}

variable "bootstrap-aws-default-region" {}
variable "bootstrap-service-account-name" {}
variable "bootstrap-service-account-policy-arn" {}
