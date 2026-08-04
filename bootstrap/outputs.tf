output "build_push_role_arn" {
  description = "ARN for build-push role for YAML files"
  value       = aws_iam_role.build_push.arn
}
output "infra_role_arn" {
  description = "ARN for infra role for YAML files"
  value       = aws_iam_role.infra.arn
}