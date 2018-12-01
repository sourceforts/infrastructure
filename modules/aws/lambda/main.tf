resource "aws_iam_role" "function_iam_role" {
  name = "${var.name}-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "function_logging" {
  name = "lambda_logging"
  path = "/"

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
  name = "lambda_logging"
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
  role = "${aws_iam_role.function_iam_role.name}"
  policy_arn = "${aws_iam_policy.function_describe_addresses.arn}"
}

resource "aws_lambda_function" "function" {
    function_name   = "${var.name}"
    s3_bucket       = "${var.bucket_name}"
    s3_key          = "${var.name}.zip"
    handler         = "index.handler"
    runtime         = "nodejs8.10"
    role            = "${aws_iam_role.function_iam_role.arn}"
    memory_size     = 1024
    timeout         = 300
}
