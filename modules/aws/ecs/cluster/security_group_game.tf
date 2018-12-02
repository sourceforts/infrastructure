resource "aws_security_group" "security_group_game" {
    name_prefix = "${var.cluster_name}-${var.instance_group}-game-"
    vpc_id      = "${var.vpc_id}"

    tags {
        cluster         = "${var.cluster_name}"
        instance_group  = "${var.instance_group}"
    }
}

resource "aws_security_group_rule" "outbound_internet_access_game_tcp" {
    type                = "egress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_game_tcp" {
    type                = "ingress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_game_udp" {
    type                = "egress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_game_udp" {
    type                = "ingress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_client_udp" {
    type                = "egress"
    from_port           = 27005
    to_port             = 27005
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_client_udp" {
    type                = "ingress"
    from_port           = 27005
    to_port             = 27005
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_stv_udp" {
    type                = "egress"
    from_port           = 27020
    to_port             = 27020
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_stv_udp" {
    type                = "ingress"
    from_port           = 27020
    to_port             = 27020
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_steam_udp" {
    type                = "egress"
    from_port           = 26900
    to_port             = 26900
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_other_udp" {
    type                = "egress"
    from_port           = 51840
    to_port             = 51840
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group_game.id}"
}
