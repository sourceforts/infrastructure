resource "aws_vpc" "vpc" {
    provider                = "${var.provider}"
    cidr_block              = "${var.cidr_block}"
    enable_dns_hostnames    = true

    tags {
        name = "${var.name}"
    }
}

resource "aws_internet_gateway" "gateway" {
    provider    = "${var.provider}"
    vpc_id      = "${aws_vpc.vpc.id}"

    tags {
        name = "${var.name}"
    }
}