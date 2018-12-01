locals {
    topic_name = "sourceforts-server-build-notification"
    function_name = "sourceforts-server-build-notification-handler"
}

module "topic" {
    source = "../aws/sns"
    name   = "${local.topic_name}"
}

module "handler" {
    source      = "../aws/lambda"

    name        = "${local.function_name}"
    bucket_name = "${var.lambda_bucket_name}"
}

resource "aws_lambda_permission" "handler_permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${local.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${module.topic.topic_arn}"
}

resource "aws_sns_topic_subscription" "handler_subscription" {
  topic_arn = "${module.topic.topic_arn}"
  protocol  = "lambda"
  endpoint  = "${module.handler.lambda_arn}"
}
