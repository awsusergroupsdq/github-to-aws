locals {
  account_id = data.aws_caller_identity.current.account_id

  github_oidc_url = "https://token.actions.githubusercontent.com"
  github_oidc     = "token.actions.githubusercontent.com"

  github_owner     = element(split("/", var.github_repository), 0)
  github_repo_name = element(split("/", var.github_repository), 1)

  # Trust-policy subjects for token.actions.githubusercontent.com:sub.
  # Must match BOTH formats GitHub emits (see
  # https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws):
  #   legacy (repos created before July 15, 2026 without opt-in):
  #     repo:awsusergroupsdq/github-to-aws:ref:refs/heads/main
  #   immutable subject claims (opted-in / created after July 15, 2026; owner and
  #   repository reduced to their immutable IDs):
  #     repo:awsusergroupsdq@313996782/github-to-aws@1424917702:ref:refs/heads/main
  github_oidc_subjects = distinct(concat(
    [
      for ref in var.github_allowed_branches :
      "repo:${var.github_repository}:ref:refs/heads/${ref}"
    ],
    [
      for ref in var.github_allowed_branches :
      "repo:${local.github_owner}@*/${local.github_repo_name}@*:ref:refs/heads/${ref}"
    ]
  ))

  app_bucket_name   = "${var.namespace}-${var.stage}-app"
  app_bucket_prefix = "arn:aws:s3:::${local.app_bucket_name}"
}
