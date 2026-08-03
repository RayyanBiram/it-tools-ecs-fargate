output "execution_role_arn" {
  description = "ARN of the execution role"
  value       = aws_iam_role.execution_role.arn
}