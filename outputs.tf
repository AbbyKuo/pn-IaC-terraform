output "website_domain" {
  value = module.pn-app-s3.website_domain
}

output "website_endpoint" {
  value = module.pn-app-s3.website_endpoint
}

output "frontend_record_name" {
  value = module.pn-app-route53.frontend_record_name
}