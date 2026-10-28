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

  role_description = "OIDC-federated role assumed by GitHub Actions from ${var.github_repository}"

  policy_description = "Least-privilege policy allowing GitHub Actions to deploy the frontend"

  principals = {
    Federated = [
      aws_iam_openid_connect_provider.github.arn
    ]
  }

  assume_role_actions = [
    "sts:AssumeRoleWithWebIdentity",
    "sts:TagSession"
  ]

  assume_role_conditions = [
    {
      test     = "StringEquals"
      variable = "${local.github_oidc}:aud"
      values   = ["sts.amazonaws.com"]
    },
    {
      test     = "StringLike"
      variable = "${local.github_oidc}:sub"
      values   = local.github_oidc_subjects
    }
  ]

  policy_documents = var.deploy_bucket != "" ? [
    data.aws_iam_policy_document.gha_deploy[0].json
  ] : []
}
