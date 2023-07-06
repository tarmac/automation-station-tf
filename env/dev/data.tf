data "aws_caller_identity" "current" {
}
data "aws_iam_policy_document" "ecs_ecr_access" {
  statement {
    effect = "Allow"

    actions = [
      "ecs:*",
      "ecr:*",
      "secretsmanager:*",
      "iam:*",
      "s3:*",
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:CreateInvalidation"
    ]

    resources = [
      "*"
    ]
  }
}