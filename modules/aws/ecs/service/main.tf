resource "aws_ecs_task_definition" "task_definition" {
    family                  = "${var.name}"
    container_definitions   = <<EOF
[
    {
        "name": "${var.name}",
        "image": "sourceforts/server",
        "cpu": 512,
        "memoryReservation": 256,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${var.name}",
                "awslogs-region": "${var.region}",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "portMappings": [
            {
                "hostPort": 27015,
                "containerPort": 27015,
                "protocol": "tcp"
            },
            {
                "hostPort": 27015,
                "containerPort": 27015,
                "protocol": "udp"
            },
            {
                "hostPort": 27005,
                "containerPort": 27005,
                "protocol": "udp"
            },
            {
                "hostPort": 27020,
                "containerPort": 27020,
                "protocol": "udp"
            },
            {
                "hostPort": 26900,
                "containerPort": 26900,
                "protocol": "udp"
            },
            {
                "hostPort": 51840,
                "containerPort": 51840,
                "protocol": "udp"
            },
            {
                "hostPort": 80,
                "containerPort": 55555,
                "protocol": "tcp"
            }
        ],
        "environment": [
            {
                "name": "HOSTNAME",
                "value": "aws-${var.region}"
            }
        ]
    }
]
EOF

    tags {
        name = "${var.name}"
    }
}

resource "aws_ecs_service" "service" {
    name            = "${var.name}-service"
    cluster         = "${var.cluster_name}"
    task_definition = "${aws_ecs_task_definition.task_definition.arn}"
    desired_count   = "${var.desired_count}"

    ordered_placement_strategy {
        type    = "binpack"
        field   = "cpu"
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_cloudwatch_log_group" "ecs-agent" {
    name              = "/ecs/${var.name}"
    retention_in_days = 30
}
