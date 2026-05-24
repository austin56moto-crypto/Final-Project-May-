resource "aws_s3_bucket" "proof_uploads" {
  bucket = "${local.project_name}-proof-uploads"
  tags   = local.tags
}

resource "aws_s3_bucket_public_access_block" "proof_uploads" {
  bucket                  = aws_s3_bucket.proof_uploads.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "proof_uploads" {
  bucket = aws_s3_bucket.proof_uploads.id

  versioning_configuration {
    status = "Enabled"
  }
}

