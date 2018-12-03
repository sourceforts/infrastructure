# TODO: Don't allow connections via HTTP(S) via anywhere on the internet!
resource "aws_security_group" "security_group_init" {
    name_prefix = "${var.cluster_name}-${var.instance_group}-init-"
    vpc_id      = "${var.vpc_id}"

    tags {
        cluster         = "${var.cluster_name}"
        instance_group  = "${var.instance_group}"
    }
}

resource "aws_security_group_rule" "outbound_internet_access_http" {
    type                = "egress"
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_init.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_http" {
    type                = "ingress"
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_init.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_https" {
    type                = "egress"
    from_port           = 443
    to_port             = 443
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_init.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_https" {
    type                = "ingress"
    from_port           = 443
    to_port             = 443
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_init.id}"
}
