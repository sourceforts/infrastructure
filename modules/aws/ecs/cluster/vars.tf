variable "region" {}
variable "cluster_name" {}
variable "vpc_id" {}
variable "instance_type" {}
variable "aws_eip_id" {}
variable "disc_server_security_group_id" {}
variable "subnet_ids" {
    type = "list"
}

variable "instance_group" {
    default = "default"
}

variable "min_size" {
    default = 1
}

variable "max_size" {
    default = 1
}

variable "desired_capacity" {
    default = 1
}

variable "custom_user_data" {
    default = ""
}

variable "ecs_config" {
    default = "echo '' > /etc/ecs/ecs.config"
}

variable "ecs_logging" {
    default = "[\"json-file\",\"awslogs\"]"
}

variable "cloudwatch_prefix" {
    default = ""
}

variable "consul_tag_key" {
    default = "consul-servers"
}

variable "consul_tag_value" {
    default = "sf-disc"
}

variable "server_rpc_port" {
  description = "The port used by servers to handle incoming requests from other agents."
  default     = 8300
}

variable "serf_lan_port" {
  description = "The port used to handle gossip in the LAN. Required by all agents."
  default     = 8301
}

variable "serf_wan_port" {
  description = "The port used by servers to gossip over the WAN to other servers."
  default     = 8302
}

variable "cli_rpc_port" {
  description = "The port used by all agents to handle RPC from the CLI."
  default     = 8400
}

variable "http_api_port" {
  description = "The port used by clients to talk to the HTTP API"
  default     = 8500
}

variable "dns_port" {
  description = "The port used to resolve DNS queries."
  default     = 8600
}

