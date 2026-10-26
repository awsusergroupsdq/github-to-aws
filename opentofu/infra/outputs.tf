output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider registered with IAM"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  description = "IAM role ARN to use with aws-actions/configure-aws-credentials (role-to-assume)"
  value       = module.github_actions_role.arn
}

output "github_actions_role_name" {
  description = "Name of the GitHub Actions OIDC role"
  value       = module.github_actions_role.name
}

output "github_actions_role_policy" {
  description = "Assume-role trust policy document of the GitHub Actions role"
  value       = module.github_actions_role.policy
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = module.codebuild_project.project_name
}

output "codebuild_project_arn" {
  description = "ARN of the CodeBuild project"
  value       = module.codebuild_project.project_arn
}

output "codebuild_service_role_arn" {
  description = "IAM role ARN used by the CodeBuild project"
  value       = module.codebuild_project.role_arn
}

output "codebuild_runner_label" {
  description = "GitHub Actions runs-on label that routes jobs to this CodeBuild runner"
  value       = "codebuild-${module.codebuild_project.project_name}-$${{ github.run_id }}-$${{ github.run_attempt }}"
}

output "frontend_deploy_permissions" {
  description = "Whether the GitHub Actions OIDC role carries S3/CloudFront frontend deploy grants (requires var.deploy_bucket)"
  value       = var.deploy_bucket != ""
}

output "state_bucket_name" {
  value = module.state.s3_bucket_id
}

output "state_bucket_arn" {
  value = module.state.s3_bucket_arn
}
