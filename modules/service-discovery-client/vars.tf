variable "cluster_name" {}
variable "cluster_size" {}
variable "cluster_tag_key" {}
variable "cluster_tag_value" {}
variable "instance_type" {}
variable "vpc_id" {}
variable "allowed_ssh_cidr_blocks" {
    type = "list"
}
variable "allowed_inbound_cidr_blocks" {
    type = "list"
}
variable "ssh_key_name" {}
