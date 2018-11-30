data "template_file" "container_definition" {
    template = "${file("${path.module}/templates/container-definition.json")}"

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
