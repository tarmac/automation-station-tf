resource "aws_iam_role" "codebuild_role_frontend" {
  name               = "codebuild_role_frontend"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codebuild.json
}

resource "aws_iam_role_policy" "codebuild_role_frontend" {
  role   = aws_iam_role.codebuild_role_frontend.name
  policy = data.aws_iam_policy_document.codebuild_role.json
}

resource "aws_iam_role" "codepipeline_role_frontend" {
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codepipeline.json
}

resource "aws_iam_role_policy" "codepipeline_policy_frontend" {
  name   = "codepipeline_policy_frontend"
  role   = aws_iam_role.codepipeline_role_frontend.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
