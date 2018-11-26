resource "aws_subnet" "subnet" {
    provider            = "${var.provider}"
    count               = "${length(var.cidr_blocks)}"
    vpc_id              = "${var.vpc_id}"
    cidr_block          = "${element(var.cidr_blocks, count.index)}"
    availability_zone   = "${element(var.availability_zones, count.index)}"

    tags {
        name = "${var.name}"
    }
}

resource "aws_route_table" "route_table" {
    provider    = "${var.provider}"
    count       = "${length(var.cidr_blocks)}"
    vpc_id      = "${var.vpc_id}"

    tags {
        name = "${var.name}"
    }
}

resource "aws_route_table_association" "route_table_association" {
    provider        = "${var.provider}"
    count           = "${length(var.cidr_blocks)}"
    subnet_id       = "${element(aws_subnet.subnet.*.id, count.index)}"
    route_table_id  = "${element(aws_route_table.subnet.*.id, count.index)}"
}