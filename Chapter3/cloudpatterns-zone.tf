# grab the existing cloudpatterns-zone in Route53
data "aws_route53_zone" "main" {
  name = "cloudpatterns.uk."
}

resource "aws_route53_zone" "book" {
  name = "book.cloudpatterns.uk"

  tags {
    Environment = "book"
  }
}

resource "aws_route53_record" "book-ns" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "book.cloudpatterns.uk"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.book.name_servers.0}",
    "${aws_route53_zone.book.name_servers.1}",
    "${aws_route53_zone.book.name_servers.2}",
    "${aws_route53_zone.book.name_servers.3}",
  ]
}