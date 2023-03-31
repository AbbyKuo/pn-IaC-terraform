# Create s3 bucket for static website
resource "aws_s3_bucket" "pn-app" {
  bucket = var.frontend_bucket_name
  tags = {
    "name" = "${var.env_prefix}-pn-app-bucket"
  }
}
resource "aws_s3_bucket_acl" "pn-app-bucket-acl" {
  bucket = aws_s3_bucket.pn-app.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "pn-app" {
  bucket = aws_s3_bucket.pn-app.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_policy" "pn-app-bucket-poloicy" {
  bucket = aws_s3_bucket.pn-app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.pn-app.arn}/*"
        Principal = "*"
      }
    ]
  })
}
