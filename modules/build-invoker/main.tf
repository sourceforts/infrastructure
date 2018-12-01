locals {
    bucket_name = "sourceforts-game-artifacts"
    function_name = "sourceforts-server-build-invoker"
}

resource "aws_s3_bucket" "artifact_bucket" {
    bucket = "${local.bucket_name}"
    acl = "private"

    versioning {
        enabled = true
    }
}

module "handler" {
    source      = "../aws/lambda"

    name        = "${local.function_name}"
    bucket_name = "${var.lambda_bucket_name}"
}

resource "aws_lambda_permission" "invoker_permission" {
    statement_id  = "AllowExecutionFromS3Bucket"
    action        = "lambda:InvokeFunction"
    function_name = "${local.function_name}"
    principal     = "s3.amazonaws.com"
    source_arn    = "${aws_s3_bucket.artifact_bucket.arn}"
}

resource "aws_s3_bucket_notification" "invoker_notification" {
    bucket = "${aws_s3_bucket.artifact_bucket.id}"

    lambda_function {
        lambda_function_arn = "${module.handler.lambda_arn}"
        events              = ["s3:ObjectCreated:*"]
        filter_suffix       = ".7z"
    }
}
