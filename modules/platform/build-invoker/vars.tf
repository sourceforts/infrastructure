variable "region" {
    description     = "AWS region to deploy"
    default         = "eu-west-2"
}

variable "lambda_bucket_name" {}
variable "depends_on" { default = [], type = "list" }
