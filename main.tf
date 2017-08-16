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
