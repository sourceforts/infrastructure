resource "aws_cloudwatch_log_group" "dmesg" {
    provider          = "${var.provider}"
    name              = "${var.cloudwatch_prefix}/var/log/dmesg"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "docker" {
    provider          = "${var.provider}"
    name              = "${var.cloudwatch_prefix}/var/log/docker"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs-agent" {
    provider          = "${var.provider}"
    name              = "${var.cloudwatch_prefix}/var/log/ecs/ecs-agent.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs-init" {
    provider          = "${var.provider}"
    name              = "${var.cloudwatch_prefix}/var/log/ecs/ecs-init.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "audit" {
    provider          = "${var.provider}"
    name              = "${var.cloudwatch_prefix}/var/log/ecs/audit.log"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "messages" {
    provider          = "${var.provider}"
    name              = "${var.cloudwatch_prefix}/var/log/messages"
    retention_in_days = 30
}