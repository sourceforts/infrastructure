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

  depends_on = ["${var.depends_on}"]
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

  depends_on = ["${var.depends_on}"]
}
