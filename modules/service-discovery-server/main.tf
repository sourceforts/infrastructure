resource "aws_autoscaling_group" "autoscaling_group" {
  name_prefix = "${var.cluster_name}"

  launch_configuration = "${aws_launch_configuration.launch_configuration.name}"

  availability_zones  = ["${var.availability_zones}"]
  vpc_zone_identifier = ["${data.aws_subnet_ids.default.ids}"]

  # Run a fixed number of instances in the ASG
  min_size             = "${var.cluster_size}"
  max_size             = "${var.cluster_size}"
  desired_capacity     = "${var.cluster_size}"
  termination_policies = ["${var.termination_policies}"]

  health_check_type         = "${var.health_check_type}"
  health_check_grace_period = "${var.health_check_grace_period}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  service_linked_role_arn   = "${var.service_linked_role_arn}"

  enabled_metrics = ["${var.enabled_metrics}"]

  tags = [
    {
      key                 = "name"
      value               = "${var.cluster_name}"
      propagate_at_launch = true
    },
    {
      key                 = "${var.cluster_tag_key}"
      value               = "${var.cluster_tag_value}"
      propagate_at_launch = true
    },
    "${var.tags}",
  ]
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix   = "${var.cluster_name}-"
  image_id      = "${join("", data.aws_ami.consul.*.image_id)}"
  instance_type = "${var.instance_type}"
  user_data     = "${data.template_file.user_data.rendered}"

  iam_instance_profile        = "${aws_iam_instance_profile.instance_profile.id}"
  key_name                    = "${var.ssh_key_name}"
  security_groups             = ["${concat(list(aws_security_group.lc_security_group.id), var.additional_security_group_ids)}"]
  placement_tenancy           = "${var.tenancy}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  ebs_optimized = "${var.root_volume_ebs_optimized}"

  root_block_device {
    volume_type           = "${var.root_volume_type}"
    volume_size           = "${var.root_volume_size}"
    delete_on_termination = "${var.root_volume_delete_on_termination}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"

  vars {
    cluster_tag_key   = "${var.cluster_tag_key}"
    cluster_tag_value = "${var.cluster_name}"
    cluster_aws_regions = "${format("(\"%s\")", join("\" \"", var.cluster_aws_regions))}"
  }
}

data "aws_ami" "consul" {
  most_recent = true

  owners = ["self"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["consul-amazon-linux-*"]
  }
}

data "aws_subnet_ids" "default" {
  vpc_id = "${var.vpc_id}"
}
