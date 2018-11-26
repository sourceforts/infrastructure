provider "aws" {
    alias   = "${local.provider_alias}"
    region  = "${var.region}"
}

module "aws_network" {
    source = "../aws/network"

    providers = {
        "aws" = "${local.provider_alias}"
    }

    name                = "${var.region}"
    vpc_cidr            = "${var.vpc_cidr}"
    subnet_cidrs        = "${var.subnet_cidrs}"
    availability_zones  = ["${var.region}a"]
    instance_type       = "${local.instance_type}"
}

module "aws_cluster" {
    source = "../aws/ecs/cluster"

    providers = {
        "aws" = "${local.provider_alias}"
    }

    name                = "${var.region}"
    cluster_name        = "sourceforts"
    vpc_id              = "${module.aws_network.vpc_id}"
    min_size            = "${var.min_size}"
    max_size            = "${var.max_size}"
    desired_capacity    = "${var.desired_capacity}"
    instance_type       = "${local.instance_type}"
    instance_group      = "${var.instance_group}"
    ecs_aws_ami         = "${local.ecs_aws_ami}"
}