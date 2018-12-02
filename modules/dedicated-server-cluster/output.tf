# TODO; Move vpc out of this cluster and pass it in instead
output "vpc_id" {
    value = "${module.aws_network.vpc_id}"
}
