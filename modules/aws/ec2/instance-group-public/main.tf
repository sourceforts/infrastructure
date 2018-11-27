resource "aws_launch_configuration" "launch_configuration" {
    name_prefix                 = "${var.name}-${var.cluster_name}-${var.instance_group}-"
    image_id                    = "${var.aws_ami}"
    instance_type               = "${var.instance_type}"
    user_data                   = "${var.user_data}"
    iam_instance_profile        = "${var.iam_instance_profile_id}"
    key_name                    = "${var.name}-${var.cluster_name}-ssh-access-key"
    security_groups             = "${var.security_groups}"
    associate_public_ip_address = true

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
