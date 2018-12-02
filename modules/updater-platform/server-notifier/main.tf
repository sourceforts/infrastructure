locals {
    topic_name = "sf-build"
    function_name = "sf-build-handler"
}

module "topic" {
    source = "../../aws/sns"
    name   = "${local.topic_name}"
}

module "handler" {
    source      = "../../aws/lambda/sns-handler"

    name                = "${local.function_name}"
    lambda_bucket_name  = "${var.lambda_bucket_name}"
    topic_arn           = "${module.topic.topic_arn}"
}
