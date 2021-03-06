resource "aws_sns_topic" "ecs_event_topic" {
    name        = "ecs-events-${var.name}-${var.cluster_name}"
    depends_on  = "${var.depends_on}"
}

data "aws_caller_identity" "current" {}

data "template_file" "ecs_task_stopped" {
    template = <<EOF
{
    "source": ["aws.ecs"],
    "detail-type": ["ECS Task State Change"],
    "detail": {
        "clusterArn": ["arn:aws:ecs:$${region}:$${account_id}:cluster/$${cluster_name}"],
        "lastStatus": ["STOPPED"],
        "stoppedReason": ["Essential container in task exited"]
    }
}
EOF

    vars {
        account_id      = "${data.aws_caller_identity.current.account_id}"
        cluster_name    = "${var.cluster_name}"
        region          = "${var.region}"
    }
}

resource "aws_cloudwatch_event_rule" "ecs_task_stopped" {
    name            = "${var.name}-${var.cluster_name}-task-stopped"
    description     = "${var.name}-${var.cluster_name} Container in task exited"
    event_pattern   = "${data.template_file.ecs_task_stopped.rendered}"

    depends_on = "${var.depends_on}"
}

resource "aws_cloudwatch_event_target" "event_fired" {
    rule        = "${aws_cloudwatch_event_rule.ecs_task_stopped.name}"
    arn         = "${aws_sns_topic.ecs_event_topic.arn}"
    input       = "{ \"message\": \"Container in task exited\", \"account_id\": \"${data.aws_caller_identity.current.account_id}\", \"cluster\": \"${var.cluster_name}\"}"
    depends_on  = "${var.depends_on}"
}