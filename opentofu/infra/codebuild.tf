locals {
  app_bucket_name   = "${var.namespace}-${var.stage}-app"
  app_bucket_prefix = "arn:aws:s3:::${local.app_bucket_name}"
}

data "aws_iam_policy_document" "codebuild_least_privilege" {
  statement {
    sid       = "CodeBuildLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.aws_region}:${local.account_id}:log-group:/aws/codebuild/*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid       = "CodeBuildLogStreams"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.aws_region}:${local.account_id}:log-group:/aws/codebuild/*:log-stream:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid       = "AppBucketManagement"
    effect    = "Allow"
    resources = [local.app_bucket_prefix, "${local.app_bucket_prefix}/*"]

    actions = ["s3:*"]
  }

  statement {
    sid       = "OpenTofuStateBucket"
    effect    = "Allow"
    resources = ["arn:aws:s3:::ug-enmedina-tfstate-783111403365-us-east-1-an"]

    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:ListBucket",
      "s3:ListBucketVersions",
    ]
  }

  statement {
    sid       = "OpenTofuStateObjects"
    effect    = "Allow"
    resources = ["arn:aws:s3:::ug-enmedina-tfstate-783111403365-us-east-1-an/*"]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
  }

  statement {
    sid    = "CloudFrontManagement"
    effect = "Allow"

    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:UpdateOriginAccessControl",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:ListTagsForResource",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
    ]

    resources = [
      "arn:aws:cloudfront::${local.account_id}:distribution/*",
      "arn:aws:cloudfront::${local.account_id}:origin-access-control/*",
    ]
  }

  statement {
    sid       = "CloudFrontServiceLinkedRole"
    effect    = "Allow"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["arn:aws:iam::${local.account_id}:role/aws-service-role/cloudfront.amazonaws.com/AWSServiceRoleForCloudFront*"]
  }
}

module "codebuild_project" {
  source  = "cloudposse/codebuild/aws"
  version = "2.0.2"

  namespace = var.namespace
  stage     = var.stage
  name      = "app"
  delimiter = "-"

  aws_region = var.aws_region

  description        = "CodeBuild-hosted GitHub Actions runner for ${var.github_repository}"
  build_image        = var.build_image
  build_compute_type = var.build_compute_type

  source_type     = "GITHUB"
  source_location = "https://github.com/${var.github_repository}"

  artifact_type = "NO_ARTIFACTS"
  cache_type    = "NO_CACHE"

  default_permissions_enabled = false
  custom_policy               = [data.aws_iam_policy_document.codebuild_least_privilege.json]

  private_repository      = var.github_pat != ""
  source_credential_token = var.github_pat
}

resource "aws_codebuild_webhook" "github_actions_runner" {
  project_name = module.codebuild_project.project_name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "WORKFLOW_JOB_QUEUED"
    }
  }
}
