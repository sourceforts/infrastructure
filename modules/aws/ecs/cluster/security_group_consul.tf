resource "aws_security_group" "security_group_consul" {
    name_prefix = "${var.cluster_name}-${var.instance_group}-consul-"
    vpc_id      = "${var.vpc_id}"

    lifecycle {
        create_before_destroy = true
    }

    tags {
        cluster         = "${var.cluster_name}"
        instance_group  = "${var.instance_group}"
    }
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.security_group_consul.id}"
}
resource "aws_security_group_rule" "allow_server_rpc_inbound" {
  type        = "ingress"
  from_port   = "${var.server_rpc_port}"
  to_port     = "${var.server_rpc_port}"
  protocol    = "tcp"
  source_security_group_id = "${var.disc_server_security_group_id}"

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_cli_rpc_inbound" {
  type        = "ingress"
  from_port   = "${var.cli_rpc_port}"
  to_port     = "${var.cli_rpc_port}"
  protocol    = "tcp"
  source_security_group_id = "${var.disc_server_security_group_id}"

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_serf_wan_tcp_inbound" {
  type        = "ingress"
  from_port   = "${var.serf_wan_port}"
  to_port     = "${var.serf_wan_port}"
  protocol    = "tcp"
  source_security_group_id = "${var.disc_server_security_group_id}"

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_serf_wan_udp_inbound" {
  type        = "ingress"
  from_port   = "${var.serf_wan_port}"
  to_port     = "${var.serf_wan_port}"
  protocol    = "udp"
  source_security_group_id = "${var.disc_server_security_group_id}"

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_http_api_inbound" {
  type        = "ingress"
  from_port   = "${var.http_api_port}"
  to_port     = "${var.http_api_port}"
  protocol    = "tcp"
  source_security_group_id = "${var.disc_server_security_group_id}"

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_dns_tcp_inbound" {
  type        = "ingress"
  from_port   = "${var.dns_port}"
  to_port     = "${var.dns_port}"
  protocol    = "tcp"
  source_security_group_id = "${var.disc_server_security_group_id}"

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_dns_udp_inbound" {
  type        = "ingress"
  from_port   = "${var.dns_port}"
  to_port     = "${var.dns_port}"
  protocol    = "udp"
  source_security_group_id = "${var.disc_server_security_group_id}"

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

# Allow inbound from ourself

resource "aws_security_group_rule" "allow_server_rpc_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.server_rpc_port}"
  to_port   = "${var.server_rpc_port}"
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_cli_rpc_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.cli_rpc_port}"
  to_port   = "${var.cli_rpc_port}"
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_serf_wan_tcp_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.serf_wan_port}"
  to_port   = "${var.serf_wan_port}"
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_serf_wan_udp_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.serf_wan_port}"
  to_port   = "${var.serf_wan_port}"
  protocol  = "udp"
  self      = true

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_http_api_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.http_api_port}"
  to_port   = "${var.http_api_port}"
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_dns_tcp_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.dns_port}"
  to_port   = "${var.dns_port}"
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.security_group_consul.id}"
}

resource "aws_security_group_rule" "allow_dns_udp_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.dns_port}"
  to_port   = "${var.dns_port}"
  protocol  = "udp"
  self      = true

  security_group_id = "${aws_security_group.security_group_consul.id}"
}
