module "ecs_instances" {
    source = "../instances"

    region                  = "${var.region}"
    name                    = "${var.name}"
    cluster_name            = "${var.cluster_name}"
    instance_group          = "${var.instance_group}"
    subnet_ids              = "${var.subnet_ids}"
    aws_ami                 = "${var.ecs_aws_ami}"
    instance_type           = "${var.instance_type}"
    min_size                = "${var.min_size}"
    max_size                = "${var.max_size}"
    desired_capacity        = "${var.desired_capacity}"
    vpc_id                  = "${var.vpc_id}"
    iam_instance_profile_id = "${aws_iam_instance_profile.ecs.id}"
    custom_user_data        = "${var.custom_user_data}"
    cloudwatch_prefix       = "${var.cloudwatch_prefix}"
}

resource "aws_ecs_cluster" "cluster" {
    name        = "${var.cluster_name}"
}