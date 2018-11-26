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

module "updater" {
    source = "modules/updater"
}

module "us-east-1" {
    source = "modules/dedicated-server-cluster"
    region = "us-east-1"

    providers = {
        "aws" = "aws.us-east-1"
    }
}

module "eu-west-2" {
    source = "modules/dedicated-server-cluster"
    region = "eu-west-2"

    providers = {
        "aws" = "aws.eu-west-2"
    }
}

module "ap-southeast-2" {
    source = "modules/dedicated-server-cluster"
    region = "ap-southeast-2"

    providers = {
        "aws" = "aws.ap-southeast-2"
    }
}
