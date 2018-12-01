resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "sourceforts-lambdas"
    acl = "private"

    versioning {
        enabled = true
    }
}

# module "server-notifier" {
#     source              = "server-notifier"
#     region              = "${var.region}"
#     lambda_bucket_name  = "${aws_s3_bucket.lambda_bucket.id}"
# }

module "build-invoker" {
    source              = "build-invoker"
    region              = "${var.region}"
    lambda_bucket_name  = "${aws_s3_bucket.lambda_bucket.id}"

    depends_on = [
        "aws_s3_bucket.lambda_bucket"
    ]
}
