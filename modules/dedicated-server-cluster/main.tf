data "aws_route53_zone" "piston_zone" {
    name = "piston.sh."
}

module "domain" {
    source = "../aws/route53/public-subdomain"

    name            = "${var.region}.sourceforts"
    root_domain     = "piston.sh"
    root_zone_id    = "${data.aws_route53_zone.piston_zone.id}"
}

module "aws_network" {
    source = "../aws/network"

    region              = "${var.region}"
    name                = "${var.region}-${var.env}"
    vpc_cidr            = "${var.vpc_cidr}"
    subnet_cidrs        = "${var.subnet_cidrs}"
    availability_zones  = ["${var.region}a"]
}

module "aws_cluster" {
    source = "../aws/ecs/cluster"

    region              = "${var.region}"
    cluster_name        = "${var.env}"
    vpc_id              = "${module.aws_network.vpc_id}"
    subnet_ids          = "${module.aws_network.subnet_ids}"
    min_size            = "${var.min_size}"
    max_size            = "${var.max_size}"
    desired_capacity    = "${var.desired_capacity}"
    instance_type       = "${local.instance_type}"
    instance_group      = "${var.instance_group}"
    aws_eip_id          = "${module.domain.aws_eip_id}"
}

module "aws_server" {
    source = "../aws/ecs/service"

    region          = "${var.region}"
    name            = "${var.region}-${var.env}"
    cluster_name    = "${var.env}"
    desired_count   = 1
}
