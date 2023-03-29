#Retrieve the certificate for *.petnanny.live
data "aws_acm_certificate" "issued_ssl_cert" {
  domain   = "*.${var.root_domain}"
  statuses = ["ISSUED"]
}


# Cloud Front Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.s3_bucket_regional_domain_name
    # aws_s3_bucket.pn-app.bucket_regional_domain_name
    origin_id   = "s3-${var.frontend_bucket_name}"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    compress         = true
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-${var.frontend_bucket_name}"
    # "s3-dev-pn-app-bucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/404.html"
  }

  aliases = ["${var.frontend_bucket_name}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:312518712322:certificate/5e24b57c-24a0-4f27-b811-66c430b94a3c"
    ssl_support_method = "sni-only"
  }

  price_class = "PriceClass_All"
}