resource "aws_s3_bucket" "cloudpatterns-state" {
  bucket = "cloudpatterns-state"
  acl    = "private"

  versioning {
    enabled = true
  }
}