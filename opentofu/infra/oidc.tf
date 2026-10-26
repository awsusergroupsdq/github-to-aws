resource "aws_iam_openid_connect_provider" "github" {
  url             = local.github_oidc_url
  client_id_list  = [var.github_oidc_audience]
  thumbprint_list = var.github_oidc_thumbprints

  tags = {
    Name   = "github-actions-oidc"
    Source = "token.actions.githubusercontent.com"
  }
}
