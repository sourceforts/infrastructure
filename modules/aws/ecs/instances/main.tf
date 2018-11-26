resource "aws_security_group" "security_group" {
    provider    = "${var.provider}"
    name        = "${var.name}-${var.cluster_name}-${var.instance_group}"
    vpc_id      = "${var.vpc_id}"

    tags {
        name            = "${var.name}"
        cluster         = "${var.cluster_name}"
        instance_group  = "${var.instance_group}"
    }
}

resource "aws_security_group_rule" "outbound_internet_access_game_tcp" {
    provider            = "${var.provider}"
    type                = "egress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_game_tcp" {
    provider            = "${var.provider}"
    type                = "ingress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_game_udp" {
    provider            = "${var.provider}"
    type                = "egress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_game_udp" {
    provider            = "${var.provider}"
    type                = "ingress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_client_udp" {
    provider            = "${var.provider}"
    type                = "egress"
    from_port           = 27005
    to_port             = 27005
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_client_udp" {
    provider            = "${var.provider}"
    type                = "ingress"
    from_port           = 27005
    to_port             = 27005
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_stv_udp" {
    provider            = "${var.provider}"
    type                = "egress"
    from_port           = 27020
    to_port             = 27020
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_stv_udp" {
    provider            = "${var.provider}"
    type                = "ingress"
    from_port           = 27020
    to_port             = 27020
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_steam_udp" {
    provider            = "${var.provider}"
    type                = "egress"
    from_port           = 26900
    to_port             = 26900
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_other_udp" {
    provider            = "${var.provider}"
    type                = "egress"
    from_port           = 51840
    to_port             = 51840
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_launch_configuration" "launch_configuration" {
    provider                = "${var.provider}"
    name_prefix             = "${var.name}-${var.cluster_name}-${var.instance_group}-"
    image_id                = "${var.aws_ami}"
    instance_type           = "${var.instance_type}"
    user_data               = "${data.template_file.user_data.rendered}"
    iam_instance_profile    = "${var.iam_instance_profile_id}"

    security_groups = [
        "${aws_security_group.security_group.instance.id}"
    ]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "asg" {
    provider                = "${var.provider}"
    name                    = "${var.name}-${var.cluster_name}-${var.instance_group}"
    max_size                = "${var.max_size}"
    min_size                = "${var.min_size}"
    desired_capacity        = "${var.desired_capacity}"
    force_delete            = true
    launch_configuration    = "${aws_launch_configuration.launch_configuration.id}"

    vpc_zone_identifier = [
        "${var.subnet_ids}"
    ]

    tag {
        key                 = "name"
        value               = "${var.name}-ecs-${var.cluster_name}-${var.instance_group}"
        propagate_at_launch = true
    }

    tag {
        key                 = "env"
        value               = "${var.name}"
        propagate_at_launch = true
    }

    tag {
        key                 = "cluster"
        value               = "${var.cluster_name}"
        propagate_at_launch = true
    }

    tag {
        key                 = "instance-group"
        value               = "${var.instance_group}"
        propagate_at_launch = true
    }
}

data "template_file" "user_data" {
    template = "${file("${path.module}/templates/user_data.sh")}"

    vars {
        ecs_config          = "${var.ecs_config}"
        ecs_logging         = "${var.ecs_logging}"
        cluster_name        = "${var.cluster_name}"
        env_name            = "${var.name}"
        custom_user_data    = "${var.custom_user_data}"
        cloudwatch_prefix   = "${var.cloudwatch_prefix}"
    }
}