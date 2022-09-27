#resource "aws_route53_zone" "myZone" {
 #name = "securitydojo.co.in"
#}

resource "aws_route53_record" "myRecord" {
  zone_id = "Z09025171ED48YQQ3R8IQ"
  name    = "devsecops.securitydojo.co.in"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.lb.dns_name]
}