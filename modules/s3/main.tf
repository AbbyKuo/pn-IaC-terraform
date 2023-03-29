# Create s3 bucket for static website
resource "aws_s3_bucket" "pn-app" {
  bucket = var.frontend_bucket_name
  acl    = "public-read"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": ["arn:aws:s3:::${var.frontend_bucket_name}/*"]
        }
    ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = {
    "Name" = "${var.env_prefix}-pn-website"
  }

}