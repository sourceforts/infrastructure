resource "aws_iam_instance_profile" "instance_profile" {
  count = "${var.enable_iam_setup}"

  name_prefix = "${var.cluster_name}"
  path        = "${var.instance_profile_path}"
  role        = "${element(coalescelist(aws_iam_role.instance_role.*.name,list("")),0)}"

  # aws_launch_configuration.launch_configuration in this module sets create_before_destroy to true, which means
  # everything it depends on, including this resource, must set it as well, or you'll get cyclic dependency errors
  # when you try to do a terraform destroy.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "instance_role" {
  count = "${var.enable_iam_setup}"

  name_prefix        = "${var.cluster_name}"
  assume_role_policy = "${data.aws_iam_policy_document.instance_role.json}"

  # aws_iam_instance_profile.instance_profile in this module sets create_before_destroy to true, which means
  # everything it depends on, including this resource, must set it as well, or you'll get cyclic dependency errors
  # when you try to do a terraform destroy.
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "instance_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "auto_discover_cluster" {
  count  = "${var.enable_iam_setup}"
  name   = "auto-discover-cluster"
  role   = "${element(coalescelist(aws_iam_role.instance_role.*.id,list("")),0)}"
  policy = "${data.aws_iam_policy_document.auto_discover_cluster.json}"
}

data "aws_iam_policy_document" "auto_discover_cluster" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "autoscaling:DescribeAutoScalingGroups",
    ]

    resources = ["*"]
  }
}
