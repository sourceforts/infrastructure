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

module "us-east-1" {
    source = "modules/dedicated-server-cluster"
    region = "us-east-1"
}

module "eu-west-2" {
    source = "modules/dedicated-server-cluster"
    region = "eu-west-2"
}

module "ap-southeast-2" {
    source = "modules/dedicated-server-cluster"
    region = "ap-southeast-2"
}
