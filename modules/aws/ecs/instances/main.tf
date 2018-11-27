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
    key_name                    = "${var.name}-${var.cluster_name}-ssh-access-key"

    security_groups = [
        "${aws_security_group.security_group_game.id}",
        "${aws_security_group.security_group_ssh.id}"
    ]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_key_pair" "ssh_access" {
    key_name    = "${var.name}-${var.cluster_name}-ssh-access-key"
    public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmzUAX4OZdMV2znUjXvhLV/qhMgu4jmRL8bt7yBqPIUEBwLbGxVupsPKxT2+FASy55pdkCKGpWOOoPgtLT4Wj/pLTkwPlRt7HJb3ie8SbU8Sp4gPAI+DsF6lC772bn5Mz16Ogb3YZEAI8csxhjJZw1RJASwPoLe62zzOhqFFOT/KQcQS119NzwLUMWawERgUaSypRac5qLYQav6zz6ePSQ9CeDQT8hk7wTg5Fp3kOed0gEZ8F7PhirJnnvU5iIsvJpiPR9+DohdObv3VXswtB8NILzSyVDcwoLZhVj0lVNSaXE6slXTQPGVslde8t4vHc2voTSzFO1otWVgxoeiCF/w== rsa-key-20181127"
}

resource "aws_eip" "instance_public_ip" {
    vpc = true
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
        eip_association     = "${aws_eip.instance_public_ip.id}"
    }
}