locals {
    bucket_name = "sourceforts-game-artifacts"
    function_name = "sourceforts-server-build-invoker"
}

module "handler" {
    source      = "../../aws/lambda/s3-handler"

    name                = "${local.function_name}"
    lambda_bucket_name  = "${var.lambda_bucket_name}"
    source_bucket_name  = "${local.bucket_name}"
}
