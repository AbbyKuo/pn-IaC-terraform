data "aws_route53_zone" "pn-zone" {
  name         = var.root_domain
  private_zone = false
}


# Find a certificate that is issued
data "aws_acm_certificate" "issued" {
  domain   = "*.${var.root_domain}"
  statuses = ["ISSUED"]
}

resource "aws_route53_record" "pn-server-record" {
  zone_id = data.aws_route53_zone.pn-zone.id
  name    = "${var.env_prefix}-backend.${data.aws_route53_zone.pn-zone.name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    # aws_lb.pn-server-alb.dns_name
    zone_id                = var.alb_zone_id
    # aws_lb.pn-server-alb.zone_id
    evaluate_target_health = true

  }
}

