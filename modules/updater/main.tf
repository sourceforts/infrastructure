provider "aws" {
    alias   = "${local.provider_alias}"
    region  = "${var.region}"
}
