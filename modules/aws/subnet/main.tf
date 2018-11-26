resource "aws_subnet" "subnet" {
    count                   = "${length(var.cidr_blocks)}"
    vpc_id                  = "${var.vpc_id}"
    cidr_block              = "${element(var.cidr_blocks, count.index)}"
    availability_zone       = "${element(var.availability_zones, count.index)}"
    map_public_ip_on_launch = true

    tags {
        name = "${var.name}"
    }
}

resource "aws_route_table" "route_table" {
    count       = "${length(var.cidr_blocks)}"
    vpc_id      = "${var.vpc_id}"

    tags {
        name = "${var.name}"
    }
}

resource "aws_route_table_association" "route_table_association" {
    count           = "${length(var.cidr_blocks)}"
    subnet_id       = "${element(aws_subnet.subnet.*.id, count.index)}"
    route_table_id  = "${element(aws_route_table.route_table.*.id, count.index)}"
}