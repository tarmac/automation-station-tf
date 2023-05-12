resource "aws_ecr_repository" "ecr_internal_dev" {
  name                 = "${var.tags["env"]}-server"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "ecr_internal_dev_lifecycle" {
  repository = aws_ecr_repository.ecr_internal_dev.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 5 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
    }]
  })
}