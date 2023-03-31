variable "root_domain" {
    description = "root domain name"
}

variable "frontend_bucket_name" {
    description = "bucket name for the static website - website domain name"
}

variable "cloudfront_s3_distribution_domian_name" {
    description = "cloudfront distribution.s3 distribution domain name"
}

variable "cloudfront_s3_distribution_hosted_zone_id" {
    description = "cloudfront distribution.s3 distribution hosted zone id"
}