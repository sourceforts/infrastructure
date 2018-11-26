resource "aws_security_group" "security_group" {
    name        = "${var.name}-${var.cluster_name}-${var.instance_group}"
    vpc_id      = "${var.vpc_id}"

    tags {
        name            = "${var.name}"
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
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_game_tcp" {
    type                = "ingress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_game_udp" {
    type                = "egress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_game_udp" {
    type                = "ingress"
    from_port           = 27015
    to_port             = 27015
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_client_udp" {
    type                = "egress"
    from_port           = 27005
    to_port             = 27005
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_client_udp" {
    type                = "ingress"
    from_port           = 27005
    to_port             = 27005
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_stv_udp" {
    type                = "egress"
    from_port           = 27020
    to_port             = 27020
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "inbound_internet_access_stv_udp" {
    type                = "ingress"
    from_port           = 27020
    to_port             = 27020
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_steam_udp" {
    type                = "egress"
    from_port           = 26900
    to_port             = 26900
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "outbound_internet_access_other_udp" {
    type                = "egress"
    from_port           = 51840
    to_port             = 51840
    protocol            = "udp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = "${aws_security_group.security_group.id}"
}

data "aws_ami" "ecs_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["self", "amazon"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "launch_configuration" {
    name_prefix                 = "${var.name}-${var.cluster_name}-${var.instance_group}-"
    image_id                    = "${join("", data.aws_ami.ecs_ami.*.image_id)}"
    instance_type               = "${var.instance_type}"
    user_data                   = "${data.template_file.user_data.rendered}"
    iam_instance_profile        = "${var.iam_instance_profile_id}"
    associate_public_ip_address = true

    security_groups = [
        "${aws_security_group.security_group.id}"
    ]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "asg" {
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
        region              = "${var.region}"
        ecs_config          = "${var.ecs_config}"
        ecs_logging         = "${var.ecs_logging}"
        cluster_name        = "${var.cluster_name}"
        env_name            = "${var.name}"
        custom_user_data    = "${var.custom_user_data}"
        cloudwatch_prefix   = "${var.cloudwatch_prefix}"
    }
}