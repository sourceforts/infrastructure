resource "aws_eip" "instance_public_ip" {
    vpc = true
}

resource "aws_route53_record" "eip" {
    zone_id = "${var.root_zone_id}"
    name    = "${var.name}.${var.root_domain}"
    type    = "A"
    ttl     = "300"
    records = ["${aws_eip.instance_public_ip.public_ip}"]
}
