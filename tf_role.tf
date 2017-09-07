# setup aws provider for dev account
provider "aws" {
  alias = "sub_account"
  region = "${var.bootstrap-aws-default-region}"
  access_key = "${var.sub_account_access_key}"
  secret_key = "${var.sub_account_secret_key}"
}

# in sub account create iam policy, which will grants rights
# right now using policy == PowerUser in AWS
# can be scoped down as we refactor
resource "aws_iam_policy" "external_tf_user_policy" {
    provider = "aws.sub_account"
    name = "ExternalTFPolicy"
    path = "/"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "NotAction": [
              "iam:*",
              "organizations:*"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": "organizations:DescribeOrganization",
          "Resource": "*"
      }
  ]
}
EOF
}

# in sub account create a role which can be assumed by main account
resource "aws_iam_role" "external_tf_role" {
    provider = "aws.sub_account"
    name = "ExternalTFRole"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.main_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# attach policy to role
resource "aws_iam_policy_attachment" "external_tf_user_policy_attachment_to_external_tf_role" {
    provider = "aws.sub_account"
    name = "external_tf_user_policy_attachment"
    roles = ["${aws_iam_role.external_tf_role.name}"]
    policy_arn = "${aws_iam_policy.external_tf_user_policy.arn}"
}

# build a bucket for future TF usage in the right account
resource "aws_s3_bucket" "tf_bucket" {
  provider = "aws.sub_account"
  bucket = "di_tf_user_bucket"
  acl    = "private"

  tags {
    Name        = "di_tf_user_bucket"
    Environment = "Billing"
  }
}
