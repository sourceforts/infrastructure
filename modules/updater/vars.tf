variable "region" {
    description     = "AWS region to deploy"
    default         = "eu-west-2"
}

locals {
    provider_alias = "updater-${var.region}"
}