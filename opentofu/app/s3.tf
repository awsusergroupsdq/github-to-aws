
data "aws_iam_policy_document" "app_bucket_policy" {
  statement {
    sid       = "AllowCloudFrontServicePrincipal"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${module.app_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "app_bucket_policy" {
  bucket = module.app_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.app_bucket_policy.json
}

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

  # Keep versioning on, but expire noncurrent versions after 7 days
  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      id     = "expire-noncurrent-versions"
      status = "Enabled"
      filter = {}

      noncurrent_version_expiration = {
        noncurrent_days = 7
      }

      expiration = {
        expired_object_delete_marker = true
      }
    }
  ]

  # Server-side encryption (SSE-S3)
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
