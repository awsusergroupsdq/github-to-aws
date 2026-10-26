variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where the static site bucket is deployed"
}

variable "namespace" {
  type        = string
  default     = "demo"
  description = "Namespace used for resource naming"
}

variable "stage" {
  type        = string
  default     = "prod"
  description = "Stage used for resource naming"
}

variable "force_destroy" {
  type        = bool
  default     = true
  description = "Allow the S3 bucket to be destroyed even when non-empty (handy for demo teardown)"
}

variable "price_class" {
  type        = string
  default     = "PriceClass_100"
  description = "CloudFront price class for the distribution"
}

variable "minimum_protocol_version" {
  type        = string
  default     = "TLSv1"
  description = "Minimum TLS protocol version enforced by CloudFront"
}
