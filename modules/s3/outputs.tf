output "website_domain" {
  value = aws_s3_bucket_website_configuration.pn-app.website_domain
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.pn-app.website_endpoint
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.pn-app.bucket_regional_domain_name
}