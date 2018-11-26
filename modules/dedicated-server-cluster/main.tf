module "aws_network" {
    source = "../aws/network"

    region              = "${var.region}"
    name                = "${var.region}"
    vpc_cidr            = "${var.vpc_cidr}"
    subnet_cidrs        = "${var.subnet_cidrs}"
    availability_zones  = ["${var.region}a"]
}

module "aws_cluster" {
    source = "../aws/ecs/cluster"

    region              = "${var.region}"
    name                = "${var.region}"
    cluster_name        = "sourceforts"
    vpc_id              = "${module.aws_network.vpc_id}"
    subnet_ids          = "${module.aws_network.subnet_ids}"
    min_size            = "${var.min_size}"
    max_size            = "${var.max_size}"
    desired_capacity    = "${var.desired_capacity}"
    instance_type       = "${local.instance_type}"
    instance_group      = "${var.instance_group}"
}