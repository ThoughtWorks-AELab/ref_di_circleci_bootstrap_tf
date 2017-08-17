resource "aws_iam_user" "circle" {
  name = "${var.bootstrap-service-account-name}"
  path = "/system/"
}

resource "aws_iam_access_key" "circle" {
  user = "${aws_iam_user.circle.name}"
}

resource "aws_iam_user_policy_attachment" "test-attach" {
    user       = "${aws_iam_user.circle.name}"
    policy_arn = "${var.bootstrap-service-account-policy-arn}"
}

output "circle_user_key" {
  value = "${aws_iam_access_key.circle.id}"
}
output "circle_user_secret" {
  value = "${aws_iam_access_key.circle.secret}"
}
