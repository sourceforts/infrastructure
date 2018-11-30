resource "aws_vpc" "vpc" {
    cidr_block              = "${var.cidr_block}"
    enable_dns_hostnames    = false

    tags {
        name = "${var.name}"
    }
}

resource "aws_internet_gateway" "gateway" {
    vpc_id      = "${aws_vpc.vpc.id}"

    tags {
        name = "${var.name}"
    }
}
