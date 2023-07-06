resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role" "ecs_task_role" {
  name = "automation-station-ecs-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "secretManager_access_policy" {
  name        = "SecretManagerAccess"
  description = "Grants access to Secret Manager"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ecs_repository_policy" {
  name        = "fargate-task-policy-image-pull"
  description = "Policy that allows access to ECR"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "ecr:BatchCheckLayerAvailability",
               "ecr:CompleteLayerUpload",
               "ecr:InitiateLayerUpload",
               "ecr:PutImage",
               "ecr:GetAuthorizationToken",
               "ecr:UploadLayerPart",
               "logs:PutLogEvents",
               "logs:GetLogEvents",
               "logs:FilterLogEvents",
               "logs:DescribeLogStreams",
               "logs:DescribeLogGroups",
               "logs:CreateLogStream",
               "logs:CreateLogGroup"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}

resource "aws_iam_policy" "ssm_policy" {
  name        = "ssm-task-policy"
  description = "Policy that allows access to SSM parameter store"
  policy      = data.aws_iam_policy_document.ssm_policy.json
}

# ECS access - task role & execution-task role
resource "aws_iam_role_policy_attachment" "secretsmanager-task-role-policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.secretManager_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_repository_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-log-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_repository_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
