
module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "6.7.1"

  enabled             = true
  comment             = "Static site distribution for the ${local.name} React app"
  default_root_object = "index.html"
  price_class         = var.price_class

  # S3 Origin Access Control
  origin_access_control = {
    app = {
      name             = local.name
      description      = "Origin Access Control for the ${local.name} static site bucket"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  # S3 origin
  origin = {
    app = {
      domain_name = module.app_bucket.s3_bucket_bucket_regional_domain_name

      origin_access_control_key = "app"
      origin_id                 = "s3-${local.name}"
    }
  }

  # Default behavior
  default_cache_behavior = {
    target_origin_id       = "s3-${local.name}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    cache_policy_name = "Managed-CachingOptimized"
  }

  # Fingerprinted static assets
  ordered_cache_behavior = [
    {
      path_pattern           = "/assets/*"
      target_origin_id       = "s3-${local.name}"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true

      cache_policy_name = "Managed-CachingOptimized"
    }
  ]

  # SPA routing fallback
  custom_error_response = [
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    },
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]

  restrictions = {
    geo_restriction = {
      restriction_type = "none"
    }
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = var.minimum_protocol_version
  }

  tags = {
    Name    = local.name
    Service = "static-site"
  }
}
