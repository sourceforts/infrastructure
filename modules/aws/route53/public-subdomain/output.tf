output "aws_eip_id" {
    value = "${aws_eip.instance_public_ip.id}"
}

output "public_ip" {
    value = "${aws_eip.instance_public_ip.public_ip}"
}
