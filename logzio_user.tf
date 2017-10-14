resource "aws_iam_user_policy" "logzio_s3_ro" {
  provider = "aws.sub_account"
  name = "CloudTrailLogsReadOnly"
  user = "${aws_iam_user.logzio_user.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::io.twdps.cloudtraillogs"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::io.twdps.cloudtraillogs/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user" "logzio_user" {
  provider = "aws.sub_account"
  name = "logzio"
  path = "/system/"
}

resource "aws_iam_access_key" "logzio_key" {
  provider = "aws.sub_account"
  user = "${aws_iam_user.logzio_user.name}"
}

output "key.logzio" {
  value = "${aws_iam_access_key.logzio_key.id}"
}

output "secret.logzio" {
  value = "${aws_iam_access_key.logzio_key.secret}"
}
