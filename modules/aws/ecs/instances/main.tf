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

resource "aws_eip" "instance_public_ip" {
    vpc = true
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

module "container_instance_group" {
    source = "../../ec2/instance-group-public"

    region                  = "${var.region}"
    name                    = "${var.name}"
    cluster_name            = "${var.cluster_name}"
    instance_group          = "${var.instance_group}"
    aws_ami                 = "${join("", data.aws_ami.ecs_ami.*.image_id)}"
    subnet_ids              = "${var.subnet_ids}"
    security_groups         = [
        "${aws_security_group.security_group_game.id}",
        "${aws_security_group.security_group_ssh.id}",
        "${aws_security_group.security_group_init.id}",
    ]
    instance_type           = "${var.instance_type}"
    min_size                = "${var.min_size}"
    max_size                = "${var.max_size}"
    desired_capacity        = "${var.desired_capacity}"
    vpc_id                  = "${var.vpc_id}"
    iam_instance_profile_id = "${var.iam_instance_profile_id}"
    user_data               = "${data.template_file.user_data.rendered}"
    cloudwatch_prefix       = "${var.cloudwatch_prefix}"
}