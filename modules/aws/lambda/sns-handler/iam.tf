resource "aws_iam_policy" "function_logging" {
  name_prefix = "${var.name}-log-"
  path        = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "function_logging_attachment" {
  role = "${aws_iam_role.function_iam_role.name}"
  policy_arn = "${aws_iam_policy.function_logging.arn}"
}

resource "aws_iam_policy" "function_describe_addresses" {
  name_prefix = "${var.name}-desc-addr-"
  path        = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeAddresses"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "function_describe_addresses_attachment" {
  role = "${aws_iam_role.function_iam_role.name}"
  policy_arn = "${aws_iam_policy.function_describe_addresses.arn}"
}
