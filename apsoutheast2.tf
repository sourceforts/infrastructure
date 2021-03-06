resource "aws_key_pair" "service_discovery_key_pair_ap" {
    provider    = "aws.ap-southeast-2"
    key_name    = "${local.discovery_cluster_name}-ssh-access-key"
    public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmzUAX4OZdMV2znUjXvhLV/qhMgu4jmRL8bt7yBqPIUEBwLbGxVupsPKxT2+FASy55pdkCKGpWOOoPgtLT4Wj/pLTkwPlRt7HJb3ie8SbU8Sp4gPAI+DsF6lC772bn5Mz16Ogb3YZEAI8csxhjJZw1RJASwPoLe62zzOhqFFOT/KQcQS119NzwLUMWawERgUaSypRac5qLYQav6zz6ePSQ9CeDQT8hk7wTg5Fp3kOed0gEZ8F7PhirJnnvU5iIsvJpiPR9+DohdObv3VXswtB8NILzSyVDcwoLZhVj0lVNSaXE6slXTQPGVslde8t4vHc2voTSzFO1otWVgxoeiCF/w== rsa-key-20181127"
}

module "service-discovery-server-ap-southeast-2" {
    source = "modules/service-discovery-server"

    cluster_name        = "${local.discovery_cluster_name}"
    cluster_size        = 1
    cluster_tag_key     = "consul-servers"
    cluster_tag_value   = "${local.discovery_cluster_name}"
    instance_type       = "t2.nano"
    vpc_id              = "${module.ap-southeast-2.vpc_id}"

    availability_zones = [
        "ap-southeast-2a",
        "ap-southeast-2b",
        "ap-southeast-2c",
    ]

    # TODO; security
    allowed_ssh_cidr_blocks     = ["0.0.0.0/0"]
    allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
    ssh_key_name                = "${aws_key_pair.service_discovery_key_pair_us.key_name}"

    providers = {
        "aws" = "aws.ap-southeast-2"
    }
}

module "ap-southeast-2" {
    source = "modules/dedicated-server-cluster"
    region = "ap-southeast-2"

    vpc_cidr = "10.2.0.0/16"
    subnet_cidrs = [
        "10.2.0.0/24"
    ]

    disc_server_security_group_id = "${module.service-discovery-server-ap-southeast-2.security_group_id}"

    providers = {
        "aws" = "aws.ap-southeast-2"
    }
}
