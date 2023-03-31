variable "root_domain" {
    description = "root domain name"
}

variable "frontend_bucket_name" {
    description = "bucket name for the static website - website domain name"
}

variable "env_prefix" {
    description = "environment prefix"
}

variable "s3_bucket_regional_domain_name" {
    description = "frontend bucket regional domain name"
}