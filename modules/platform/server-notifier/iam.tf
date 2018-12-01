resource "aws_iam_policy" "function_describe_addresses" {
  name = "function_describe_addresses"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeAddresses",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "function_describe_addresses_attachment" {
  role = "${module.handler.lambda_role_name}"
  policy_arn = "${aws_iam_policy.function_describe_addresses.arn}"
}
