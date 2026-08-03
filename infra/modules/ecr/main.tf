data "aws_ecr_repository" "ecr" {
  name   = var.repository_name
  region = var.aws_region
}