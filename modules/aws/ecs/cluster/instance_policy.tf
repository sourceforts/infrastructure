resource "aws_iam_role" "ecs_instance_role" {
    provider    = "${var.provider}"
    name        = "${var.name}-ecs-instance-role"

    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs" {
    provider    = "${var.provider}"
    name        = "${var.name}-ecs-instance-profile"
    path        = "/"
    role        = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
    provider    = "${var.provider}"
    role        = "${aws_iam_role.ecs_instance_role.id}"
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
    provider    = "${var.provider}"
    role        = "${aws_iam_role.ecs_instance_role.id}"
    policy_arn  = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}