# TODO: Don't allow connections via SSH via anywhere on the internet!
resource "aws_security_group" "security_group_ssh" {
    name_prefix = "${var.cluster_name}-${var.instance_group}-ssh-"
    vpc_id      = "${var.vpc_id}"

    tags {
        cluster         = "${var.cluster_name}"
        instance_group  = "${var.instance_group}"
    }
}

resource "aws_security_group_rule" "outbound_internet_access_ssh" {
    type                = "egress"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_ssh.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_ssh" {
    type                = "ingress"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_ssh.id}"
}
