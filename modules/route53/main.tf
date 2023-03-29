data "aws_route53_zone" "zone" {
  name         = var.root_domain
  private_zone = false
}

resource "aws_route53_record" "frontend_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.frontend_bucket_name
  type    = "A"
  alias {
    name                   = var.cloudfront_s3_distribution_domian_name
    # aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = var.cloudfront_s3_distribution_hosted_zone_id
    # aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}




