
module "app_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.15.4"

  bucket        = local.name
  force_destroy = var.force_destroy

  tags = {
    Name    = local.name
    Service = "static-site"
  }

  # Block all public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Object ownership
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  # Enable bucket versioning
  versioning = {
    enabled = true
  }

  # Server-side encryption (SSE-S3)
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
