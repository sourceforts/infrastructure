resource "aws_vpc_peering_connection" "eu_us_peer" {
    provider    = "aws.eu-west-2"

    vpc_id      = "${module.eu-west-2.vpc_id}"
    peer_vpc_id = "${module.us-east-1.vpc_id}"
    peer_region = "us-east-1"
}

resource "aws_vpc_peering_connection_accepter" "eu_us_peer_accept" {
    provider                  = "aws.us-east-1"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.eu_us_peer.id}"
    auto_accept               = true
}

resource "aws_vpc_peering_connection" "eu_ap_peer" {
    provider    = "aws.eu-west-2"

    vpc_id      = "${module.eu-west-2.vpc_id}"
    peer_vpc_id = "${module.ap-southeast-2.vpc_id}"
    peer_region = "ap-southeast-2"
}

resource "aws_vpc_peering_connection_accepter" "eu_ap_peer_accept" {
    provider                  = "aws.ap-southeast-2"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.eu_ap_peer.id}"
    auto_accept               = true
}

resource "aws_vpc_peering_connection" "us_ap_peer" {
    provider    = "aws.us-east-1"

    vpc_id      = "${module.us-east-1.vpc_id}"
    peer_vpc_id = "${module.ap-southeast-2.vpc_id}"
    peer_region = "ap-southeast-2"
}

resource "aws_vpc_peering_connection_accepter" "us_ap_peer_accept" {
    provider                  = "aws.ap-southeast-2"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.us_ap_peer.id}"
    auto_accept               = true
}
