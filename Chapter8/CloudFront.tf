resource "aws_s3_bucket" "cloudpatterns-cloudfrontbucket" {
  bucket = "cloudpatterns-cloudfront"
  acl = "private"

  tags = {
    Name = "My cloudfront bucket"
  }
}

resource "aws_s3_bucket_object" "helloA" {
    bucket = "cloudpatterns-cloudfront"
    key = "index.html"
    content = "Hello world from Terraform!"
    content_type = "text/plain"
    acl = "public-read"
}

resource "aws_s3_bucket_object" "helloB" {
    bucket = "cloudpatterns-cloudfront"
    key = "indexB.html"
    content = "Hello world from TerraformB!"
    content_type = "text/plain"
    acl = "public-read"
}

locals {
  s3_origin_id = "cloudpatterns-cloudfront"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.cloudpatterns-cloudfrontbucket.bucket_regional_domain_name}"
    origin_id = "${local.s3_origin_id}"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    }
  }

  enabled = true
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket = "mylogs.s3.amazonaws.com"
    prefix = "cloudfrontprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "${local.s3_origin_id}"
    
    lambda_function_association {
      event_type = "viewer-request"
      lambda_arn = "${aws_lambda_function.cloudfront_terraform_lambda.qualified_arn}"
      include_body = false
    }

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}