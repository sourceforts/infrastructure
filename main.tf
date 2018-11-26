variable "ds-regions" {
    type = "list"
    default = ["us-east-1", "eu-west-2", "ap-southeast-2"]
}

terraform {
    backend "s3" {
        bucket      = "sourceforts-infrastructure-state"
        key         = "sourceforts.tfstate"
        region      = "eu-west-2"
    }
}

module "updater" {
    source = "modules/updater"
}

module "dedicated-server-cluster" {
    source = "modules/dedicated-server-cluster"
    count = "${length(var.ds-regions)}"
    region = "${var.ds-regions[count]}"
}
