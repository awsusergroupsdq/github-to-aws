variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where the demo infrastructure is deployed"
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

variable "github_repository" {
  type        = string
  description = "GitHub repository allowed to federate into IAM, in 'owner/repo' form, e.g. 'my-org/github-to-aws'. Trust is pinned to github_allowed_branches and covers both the legacy sub format and the new immutable subject claim format (owner@id/repo@id) used by repositories created after July 15, 2026 or opted in to immutable subject claims."

  validation {
    condition     = can(regex("^[A-Za-z0-9-]+/[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "github_repository must be in 'owner/repo' form, e.g. 'my-org/github-to-aws'."
  }
}

variable "github_allowed_branches" {
  type        = list(string)
  default     = ["main"]
  description = "List of branches allowed to assume the GitHub Actions OIDC role (least privilege: pin trust to specific refs)"
}

variable "github_oidc_audience" {
  type        = string
  default     = "sts.amazonaws.com"
  description = "Audience claim (aud) required in the GitHub OIDC token"
}

variable "github_oidc_thumbprints" {
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
  description = "Thumbprints for the GitHub OIDC provider certificate chain"
}

variable "github_pat" {
  type        = string
  default     = ""
  description = "Optional GitHub personal access token used to connect the CodeBuild project to the repository (required the first time a project links to GitHub); empty relies on an existing account-level connection"
}

variable "deploy_bucket" {
  type        = string
  default     = "ug-enmanuel-prod-app"
  description = "Optional name of the S3 bucket (from opentofu/app output bucket_name) that GitHub Actions may sync frontend artifacts into; empty disables the deploy grants"
}

variable "build_image" {
  type        = string
  default     = "aws/codebuild/amazonlinux-x86_64-standard:6.0"
  description = "CodeBuild build container image (Amazon Linux 2023)"
}

variable "build_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "CodeBuild compute type"
}
