data "aws_ecs_task_definition" "ecs" {
  for_each        = var.config_services
  task_definition = aws_ecs_task_definition.ecs[each.key].family
}

# data "aws_route53_zone" "automation" {
#   name         = "${var.tags["env"]}.${var.tags["projectname"]}.com"
#   private_zone = false
# }

data "aws_iam_policy_document" "ssm_policy" {
  statement {
    sid = "1"

    actions = [
      "ssm:GetParameters"
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${var.aws_acc_id}:parameter/${var.environment}/internaltool/*"
    ]
  }
}
data "aws_acm_certificate" "automation_station" {
  domain   = "*.usetrace.com"
  statuses = ["ISSUED"]
}