data "aws_iam_policy_document" "gha_assume" {
  statement {
    sid       = "IdentityCheck"
    effect    = "Allow"
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "gha_deploy" {
  count = var.deploy_bucket != "" ? 1 : 0

  statement {
    sid    = "FrontendDeployS3"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${var.deploy_bucket}",
      "arn:aws:s3:::${var.deploy_bucket}/*",
    ]
  }

  statement {
    sid    = "OpenTofuStateRead"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::ug-enmedina-tfstate-783111403365-us-east-1-an",
      "arn:aws:s3:::ug-enmedina-tfstate-783111403365-us-east-1-an/app/*",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
    ]
  }

  statement {
    sid       = "FrontendCloudFrontInvalidation"
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation", "cloudfront:GetInvalidation"]
    resources = ["arn:aws:cloudfront::${local.account_id}:distribution/*"]
  }
}

module "github_actions_role" {
  source  = "cloudposse/iam-role/aws"
  version = "1.0.0"

  namespace = var.namespace
  stage     = var.stage
  name      = "gha-oidc"
  delimiter = "-"

  role_description   = "OIDC-federated role assumed by GitHub Actions from ${var.github_repository}"
  policy_description = "Least-privilege policy allowing GitHub Actions to trigger the demo CodeBuild project${var.deploy_bucket != "" ? " and deploy the frontend to s3://${var.deploy_bucket}" : ""}"

  principals = {
    Federated = [aws_iam_openid_connect_provider.github.arn]
  }

  assume_role_conditions = [
    {
      test     = "StringEquals"
      variable = "${local.github_oidc_url}:aud"
      values   = [var.github_oidc_audience]
    },
    {
      test     = "StringLike"
      variable = "${local.github_oidc_url}:sub"
      values   = local.github_oidc_subjects
    }
  ]

  policy_documents = concat(
    [data.aws_iam_policy_document.gha_assume.json],
    var.deploy_bucket != "" ? [one(data.aws_iam_policy_document.gha_deploy[*].json)] : [],
  )
}
