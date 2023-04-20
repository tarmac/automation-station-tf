output "ecr_arn" {
  description = "dev-internal ECR repository"
  value       = aws_ecr_repository.ecr_internal_dev.arn
}