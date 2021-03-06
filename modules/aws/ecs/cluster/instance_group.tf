data "aws_ami" "game_host" {
  most_recent = true

  owners = ["self"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["game-host-amazon-linux-*"]
  }
}

data "template_file" "user_data" {
    template = "${file("${path.module}/templates/user_data.sh")}"

    vars {
        region              = "${var.region}"
        ecs_config          = "${var.ecs_config}"
        ecs_logging         = "${var.ecs_logging}"
        cluster_name        = "${var.cluster_name}"
        custom_user_data    = "${var.custom_user_data}"
        cloudwatch_prefix   = "${var.cloudwatch_prefix}"
        eip_allocation_id   = "${var.aws_eip_id}"
        consul_tag_key      = "${var.consul_tag_key}"
        consul_tag_value    = "${var.consul_tag_value}"
    }
}

module "container_instance_group" {
    source = "../../ec2/instance-group-public"

    cluster_name            = "${var.cluster_name}"
    instance_group          = "${var.instance_group}"
    aws_ami                 = "${join("", data.aws_ami.game_host.*.image_id)}"
    subnet_ids              = "${var.subnet_ids}"
    security_groups         = [
        "${aws_security_group.security_group_game.id}",
        "${aws_security_group.security_group_ssh.id}",
        "${aws_security_group.security_group_init.id}",
        "${aws_security_group.security_group_consul.id}"
    ]
    instance_type           = "${var.instance_type}"
    min_size                = "${var.min_size}"
    max_size                = "${var.max_size}"
    desired_capacity        = "${var.desired_capacity}"
    iam_instance_profile_id = "${aws_iam_instance_profile.ecs.id}"
    user_data               = "${data.template_file.user_data.rendered}"
    cloudwatch_prefix       = "${var.cloudwatch_prefix}"
}
