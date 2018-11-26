resource "aws_iam_role" "ecs_default_task" {
    provider    = "${var.provider}"
    name        = "${var.name}-${var.cluster_name}-default-task"
    path        = "/ecs/"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

data "template_file" "policy" {
    template = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": ["ssm:DescribeParameters"],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": ["ssm:GetParameters"],
      "Effect": "Allow",
      "Resource": "arn:aws:ssm:$${region}:$${account_id}:parameter/$${prefix}*"
    }
  ]
}
EOF

    vars {
        account_id  = "${data.aws_caller_identity.current.account_id}"
        prefix      = "${var.prefix}"
        region      = "${var.region}"
    }
}

resource "aws_iam_policy" "ecs_default_task" {
    provider    = "${var.provider}"
    name        = "${var.name}-${var.cluster}-ecs-default-task"
    path        = "/"

    policy = "${data.template_file.policy.rendered}"
}

resource "aws_iam_policy_attachment" "ecs_default_task" {
    provider    = "${var.provider}"
    name        = "${var.name}-${var.cluster_name}-ecs-default-task"
    policy_arn  = "${aws_iam_policy.ecs_default_task.arn}"

    roles = [
        "${aws_iam_role.ecs_default_task.name}"
    ]
}