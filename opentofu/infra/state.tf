module "state" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.17.0"

  bucket           = "ug-enmedina-tfstate-${local.account_id}-${var.aws_region}-an"
  bucket_namespace = "account-regional"

  force_destroy = false

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_require_latest_tls_policy = true

  tags = {
    Name        = "opentofu-state"
    Environment = "shared"
    ManagedBy   = "OpenTofu"
    Purpose     = "terraform-state"
  }
}
