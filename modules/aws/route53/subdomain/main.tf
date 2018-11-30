resource "aws_eip" "instance_public_ip" {
    vpc = true
}
resource "aws_route53_zone" "hosted_zone" {
    name = "${var.name}.${var.root_domain}"
}

resource "aws_route53_record" "nameservers" {
    zone_id = "${aws_route53_zone.hosted_zone.zone_id}"
    name    = "${var.name}.${var.root_domain}"
    type    = "NS"
    ttl     = "30"

    records = [
    "${aws_route53_zone.hosted_zone.name_servers.0}",
    "${aws_route53_zone.hosted_zone.name_servers.1}",
    "${aws_route53_zone.hosted_zone.name_servers.2}",
    "${aws_route53_zone.hosted_zone.name_servers.3}",
    ]
}

resource "aws_route53_record" "root_nameservers" {
    zone_id = "${var.root_zone_id}"
    name    = "${var.name}.${var.root_domain}"
    type    = "NS"
    ttl     = "30"

    records = [
        "${aws_route53_zone.hosted_zone.name_servers.0}",
        "${aws_route53_zone.hosted_zone.name_servers.1}",
        "${aws_route53_zone.hosted_zone.name_servers.2}",
        "${aws_route53_zone.hosted_zone.name_servers.3}",
    ]
}

resource "aws_route53_record" "eip" {
    zone_id = "${aws_route53_zone.hosted_zone.zone_id}"
    name    = "${var.name}.${var.root_domain}"
    type    = "A"
    ttl     = "300"
    records = ["${aws_eip.instance_public_ip.public_ip}"]
}
