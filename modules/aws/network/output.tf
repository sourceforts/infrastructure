output "vpc_id" {
    value = "${module.vpc.vpc_id}"
}

output "vpc_cidr_block" {
    value = "${module.vpc.cidr_block}"
}

output "subnet_ids" {
    value = "${module.subnet.subnet_ids}"
}