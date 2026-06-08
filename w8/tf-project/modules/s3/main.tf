resource "aws_s3_bucket" "static_assets" {
  bucket        = "${var.project_name}-${var.env}-static-assets-${var.account_id}"
  force_destroy = true

  tags = { Name = "${var.project_name}-${var.env}-static-assets" }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.static_assets.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.static_assets.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.static_assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
