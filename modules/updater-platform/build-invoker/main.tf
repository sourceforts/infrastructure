locals {
    bucket_name = "sf-artifacts"
    function_name = "sf-build-invoker"
}

module "handler" {
    source      = "../../aws/lambda/s3-handler"

    name                = "${local.function_name}"
    lambda_bucket_name  = "${var.lambda_bucket_name}"
    source_bucket_name  = "${local.bucket_name}"
}
