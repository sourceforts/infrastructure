terraform {
    backend "s3" {
        bucket      = "sourceforts-infrastructure-state"
        key         = "sourceforts.tfstate"
        region      = "eu-west-2"
    }
}

provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}

provider "aws" {
    alias = "eu-west-2"
    region = "eu-west-2"
}

provider "aws" {
    alias = "ap-southeast-2"
    region = "ap-southeast-2"
}

locals {
    discovery_cluster_name = "sf-disc"
}

module "updater-platform" {
    source = "modules/updater-platform"
    region = "eu-west-2"

    providers = {
        "aws" = "aws.eu-west-2"
    }   
}
