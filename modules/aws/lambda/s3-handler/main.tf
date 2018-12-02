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

resource "aws_s3_bucket" "artifact_bucket" {
    bucket = "${var.source_bucket_name}"
    acl = "private"

    versioning {
        enabled = true
    }
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

resource "aws_lambda_permission" "invoker_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${var.name}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.artifact_bucket.arn}"

  depends_on = [
    "aws_lambda_function.function"
  ]
}

resource "aws_s3_bucket_notification" "invoker_notification" {
  bucket = "${aws_s3_bucket.artifact_bucket.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.function.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".7z"
  }

  depends_on = [
    "aws_lambda_function.function"
  ]
}
