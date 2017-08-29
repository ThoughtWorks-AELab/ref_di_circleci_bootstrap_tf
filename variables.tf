terraform {
  required_version = ">= 0.9.0"

  backend "s3" {
  }
}

# The reference architecture assumes the bootstrap network lives in the AWS Production account
# and credentials set in the ENV
provider "aws" {
  region = "${var.bootstrap-aws-default-region}"
  alias = "billing"
}

variable "bootstrap-aws-default-region" {}
variable "main_account_id" {}
variable "main_access_key" {}
variable "main_secret_key" {}

variable "sub_account_account_id" {}
variable "sub_account_access_key" {}
variable "sub_account_secret_key" {}
