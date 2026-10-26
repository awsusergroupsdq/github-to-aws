output "bucket_name" {
  description = "Name of the S3 bucket receiving the dist/ deploy artifacts"
  value       = module.app_bucket.s3_bucket_id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket receiving the dist/ deploy artifacts"
  value       = module.app_bucket.s3_bucket_arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (use for cache invalidations from the deploy pipeline)"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "website_url" {
  description = "Public URL of the deployed React app"
  value       = "https://${module.cloudfront.cloudfront_distribution_domain_name}"
}
