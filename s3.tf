resource "aws_s3_bucket" "foo" {
  bucket        = "netspi-screening-abc123"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "foo" {
  bucket = aws_s3_bucket.foo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
