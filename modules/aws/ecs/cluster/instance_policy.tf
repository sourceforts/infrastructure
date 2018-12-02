resource "aws_iam_role" "ecs_instance_role" {
    name_prefix = "${var.cluster_name}-${var.instance_group}-role-"

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

resource "aws_iam_role_policy" "association_policy" {
  name = "${var.cluster_name}-${var.instance_group}-policy-"
  role = "${aws_iam_role.ecs_instance_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
         "ec2:AssociateAddress",
         "ec2:DisassociateAddress",
         "ec2:ReleaseAddress"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs" {
    name_prefix = "${var.cluster_name}-${var.instance_group}-profile-"
    path        = "/"
    role        = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
    role        = "${aws_iam_role.ecs_instance_role.id}"
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
    role        = "${aws_iam_role.ecs_instance_role.id}"
    policy_arn  = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
