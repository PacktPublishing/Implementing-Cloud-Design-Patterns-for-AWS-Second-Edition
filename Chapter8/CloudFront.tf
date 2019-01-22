resource "aws_s3_bucket" "cloudpatterns-cloudfrontbucket" {
  bucket = "cloudpatterns-cloudfront"
  acl = "public-read"
  
  website {
    index_document = "index.html"
  }

  tags = {
    Name = "My cloudfront bucket"
  }
}

resource "aws_s3_bucket_object" "helloA" {
    bucket = "${aws_s3_bucket.cloudpatterns-cloudfrontbucket.bucket}"
    key = "index.html"
    content = "Hello world from Terraform!"
    content_type = "text/plain"
    acl = "public-read"
}

resource "aws_s3_bucket_object" "helloB" {
    bucket = "${aws_s3_bucket.cloudpatterns-cloudfrontbucket.bucket}"
    key = "indexB.html"
    content = "Hello world from TerraformB!"
    content_type = "text/plain"
    acl = "public-read"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.cloudpatterns-cloudfrontbucket.bucket_domain_name}"
    origin_id = "cloudpatterns-cloudfront"
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "cloudpatterns-cloudfront"
    
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