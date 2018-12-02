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

module "eu-west-2" {
    source = "modules/dedicated-server-cluster"
    region = "eu-west-2"

    providers = {
        "aws" = "aws.eu-west-2"
    }
}

module "us-east-1" {
    source = "modules/dedicated-server-cluster"
    region = "us-east-1"

    providers = {
        "aws" = "aws.us-east-1"
    }
}

module "ap-southeast-2" {
    source = "modules/dedicated-server-cluster"
    region = "ap-southeast-2"

    providers = {
        "aws" = "aws.ap-southeast-2"
    }
}

resource "aws_vpc_peering_connection" "eu_us_peer" {
    provider    = "aws.eu-west-2"
    peer_vpc_id = "${module.eu-west-2.vpc_id}"
    vpc_id      = "${module.us-east-1.vpc_id}"
}

resource "aws_vpc_peering_connection" "eu_ap_peer" {
    provider    = "aws.eu-west-2"
    peer_vpc_id = "${module.eu-west-2.vpc_id}"
    vpc_id      = "${module.ap-southeast-2.vpc_id}"
}

resource "aws_vpc_peering_connection" "us_ap_peer" {
    provider    = "aws.eu-west-2"
    peer_vpc_id = "${module.us-east-1.vpc_id}"
    vpc_id      = "${module.ap-southeast-2.vpc_id}"
}

module "updater-platform" {
    source = "modules/updater-platform"
    region = "eu-west-2"

    providers = {
        "aws" = "aws.eu-west-2"
    }   
}

locals {
    discovery_cluster_name = "sf-disc"
}

resource "aws_key_pair" "service_discovery_key_pair" {
    key_name    = "${local.discovery_cluster_name}-ssh-access-key"
    public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmzUAX4OZdMV2znUjXvhLV/qhMgu4jmRL8bt7yBqPIUEBwLbGxVupsPKxT2+FASy55pdkCKGpWOOoPgtLT4Wj/pLTkwPlRt7HJb3ie8SbU8Sp4gPAI+DsF6lC772bn5Mz16Ogb3YZEAI8csxhjJZw1RJASwPoLe62zzOhqFFOT/KQcQS119NzwLUMWawERgUaSypRac5qLYQav6zz6ePSQ9CeDQT8hk7wTg5Fp3kOed0gEZ8F7PhirJnnvU5iIsvJpiPR9+DohdObv3VXswtB8NILzSyVDcwoLZhVj0lVNSaXE6slXTQPGVslde8t4vHc2voTSzFO1otWVgxoeiCF/w== rsa-key-20181127"
}

module "service-discovery-cluster" {
    source = "modules/service-discovery-cluster"

    cluster_name        = "${local.discovery_cluster_name}"
    cluster_size        = 3
    cluster_tag_key     = "consul-servers"
    cluster_tag_value   = "${local.discovery_cluster_name}"
    instance_type       = "t2.nano"
    vpc_id              = "${module.eu-west-2.vpc_id}"

    availability_zones = [
        "eu-west-2a",
        "eu-west-2b",
        "eu-west-2c",
    ]

    # TODO; security
    allowed_ssh_cidr_blocks     = ["0.0.0.0/0"]
    allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
    ssh_key_name                = "${aws_key_pair.service_discovery_key_pair.key_name}"

    providers = {
        "aws" = "aws.eu-west-2"
    }
}

module "service-discovery-client-eu-west-2" {
    source = "modules/service-discovery-client"

    cluster_name        = "${local.discovery_cluster_name}-client"
    cluster_size        = 1
    cluster_tag_key     = "consul-clients"
    cluster_tag_value   = "${local.discovery_cluster_name}"
    instance_type       = "t2.nano"
    vpc_id              = "${module.eu-west-2.vpc_id}"

    availability_zones = [
        "eu-west-2a",
        "eu-west-2b",
        "eu-west-2c",
    ]

    # TODO; security
    allowed_ssh_cidr_blocks     = ["0.0.0.0/0"]
    allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
    ssh_key_name                = "${aws_key_pair.service_discovery_key_pair.key_name}"

    providers = {
        "aws" = "aws.eu-west-2"
    }
}

module "service-discovery-client-us-east-1" {
    source = "modules/service-discovery-client"

    cluster_name        = "${local.discovery_cluster_name}-client"
    cluster_size        = 1
    cluster_tag_key     = "consul-clients"
    cluster_tag_value   = "${local.discovery_cluster_name}"
    instance_type       = "t2.nano"
    vpc_id              = "${module.us-east-1.vpc_id}"

    availability_zones = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c",
    ]

    # TODO; security
    allowed_ssh_cidr_blocks     = ["0.0.0.0/0"]
    allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
    ssh_key_name                = "${aws_key_pair.service_discovery_key_pair.key_name}"

    providers = {
        "aws" = "aws.us-east-1"
    }
}

module "service-discovery-client-ap-southeast-2" {
    source = "modules/service-discovery-client"

    cluster_name        = "${local.discovery_cluster_name}-client"
    cluster_size        = 1
    cluster_tag_key     = "consul-clients"
    cluster_tag_value   = "${local.discovery_cluster_name}"
    instance_type       = "t2.nano"
    vpc_id              = "${module.ap-southeast-2.vpc_id}"

    availability_zones = [
        "ap-southeast-2a",
        "ap-southeast-2b",
        "ap-southeast-2c",
    ]

    # TODO; security
    allowed_ssh_cidr_blocks     = ["0.0.0.0/0"]
    allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
    ssh_key_name                = "${aws_key_pair.service_discovery_key_pair.key_name}"
    
    providers = {
        "aws" = "aws.ap-southeast-2"
    }
}
