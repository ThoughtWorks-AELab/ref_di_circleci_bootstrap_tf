# setup aws provider for main account
provider "aws" {
    alias = "main"
    region = "${var.bootstrap-aws-default-region}"
    access_key = "${var.main_access_key}"
    secret_key = "${var.main_secret_key}"
}

# create a group, which will be able to assume "ExternalAdminRole" from dev account
resource "aws_iam_group" "sub_account_tf_users" {
    provider = "aws.main"
    name = "TFUsersGroup"
}

# create a group policy, which allows to assume "ExternalAdminRole"
resource "aws_iam_group_policy" "sub_account_tf_users_policy" {
    provider = "aws.main"
    name = "TFUsersPolicy"
    group = "${aws_iam_group.sub_account_tf_users.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "${aws_iam_role.external_tf_role.arn}"
    }
}
EOF
}

# create a user "tf_user"
resource "aws_iam_user" "tf_user" {
    provider = "aws.billing"
    name = "tf_user"
}

# add "tf_user" to sub_account_tf_users group
resource "aws_iam_group_membership" "sub_account_tf_users" {
    provider = "aws.billing"
    name = "sub_account_tf_users_group_membership"
    users = [
        "${aws_iam_user.tf_user.name}"
    ]
    group = "${aws_iam_group.sub_account_tf_users.name}"
}

resource "aws_iam_access_key" "tf_user" {
  user    = "${aws_iam_user.tf_user.name}"
}

output "key" {
  value = "${aws_iam_access_key.tf_user.id}"
}

output "secret" {
  value = "${aws_iam_access_key.tf_user.secret}"
}
