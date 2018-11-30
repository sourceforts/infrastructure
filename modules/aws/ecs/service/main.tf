data "template_file" "container_definition" {
    template = <<DEFINITION
[
    {
        "name": "${name}"
        "image": "${image}",
        "cpu": ${cpu_reservation},
        "memoryReservation": ${mem_reservation},
        "logConfiguration": {
            "logDriver": "awslogs"
        },
        "portMappings": [
            {
                "hostPort": 27015,
                "protocol": "tcp",
                "containerPort": 27015
            },
            {
                "hostPort": 27015,
                "protocol": "udp",
                "containerPort": 27015
            },
            {
                "hostPort": 27005,
                "protocol": "udp",
                "containerPort": 27005
            },
            {
                "hostPort": 27020,
                "protocol": "udp",
                "containerPort": 27020
            },
            {
                "hostPort": 26900,
                "protocol": "udp",
                "containerPort": 26900
            },
            {
                "hostPort": 51840,
                "protocol": "udp",
                "containerPort": 51840
            }
      ],
      "environment": [
            {
                "name": "HOSTNAME",
                "value": "aws-${hostname}"
            }
      ],      
    }
]
DEFINITION

    vars {
        name            = "${var.name}"
        image           = "sourceforts/server"
        cpu_reservation = 512
        mem_reservation = 256
        hostname        = "${var.region}"
    }
}
resource "aws_ecs_task_definition" "task_definition" {
    family = "${var.name}"
    container_definitions = "${data.template_file.container_definition.rendered}"
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
