# Global Traffic Management using DNS
resource "aws_route53_record" "wwwltm" {
  zone_id = "${aws_route53_zone.book.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elb.cloudelb.dns_name}"]
}