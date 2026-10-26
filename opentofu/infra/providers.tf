provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id

  github_oidc_url = "https://token.actions.githubusercontent.com"

  github_oidc_subjects = formatlist("repo:%s:ref:refs/heads/%s", var.github_repository, var.github_allowed_branches)
}
