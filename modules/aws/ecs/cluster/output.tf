output "ecs_instance_security_group_id" {
    value = "${aws_security_group.security_group_game.id}"
}
