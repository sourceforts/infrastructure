resource "aws_iam_role" "function_iam_role" {
  name_prefix = "${var.name}-role-"

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

resource "aws_lambda_function" "function" {
  function_name   = "${var.name}"
  s3_bucket       = "${var.lambda_bucket_name}"
  s3_key          = "${var.name}.zip"
  handler         = "index.handler"
  runtime         = "nodejs8.10"
  role            = "${aws_iam_role.function_iam_role.arn}"
  memory_size     = 1024
  timeout         = 300
}

resource "aws_lambda_permission" "handler_permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${var.name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${var.topic_arn}"

  depends_on = [
    "aws_lambda_function.function"
  ]
}

resource "aws_sns_topic_subscription" "handler_subscription" {
  topic_arn = "${var.topic_arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.function.arn}"

  depends_on = [
    "aws_lambda_function.function"
  ]
}
