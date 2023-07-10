resource "aws_codebuild_project" "backend" {
  name          = "backend"
  description   = "backend-serverless"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codepipeline_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/tarmac/automation-station/"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }
  }

}

resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:us-east-1:785700991304:connection/c9ed8d93-ee25-40c0-83f5-ebaa9eb52524" #created manually need to find way to be imported
        FullRepositoryId = "automation-station"
        BranchName       = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "backend"
      }
    }
  }
}

# resource "aws_codepipeline_webhook" "codepipeline_webhook" {
#   name            = "test-webhook-github-bar"
#   authentication  = "GITHUB_HMAC"
#   target_action   = "Source"
#   target_pipeline = aws_codepipeline.tf-test-pipeline.name

#   authentication_configuration {
#     secret_token = data.aws_ssm_parameter.webhook_secret.value
#   }

#   filter {
#     json_path    = "$.ref"
#     match_equals = "refs/heads/{Branch}"
#   }
# }

# resource "github_repository_webhook" "bar" {
#   repository = github_repository.repo.name

#   name = "web"

#   configuration {
#     url          = aws_codepipeline_webhook.codepipeline_webhook.url
#     content_type = "json"
#     insecure_ssl = true
#     secret       = data.aws_ssm_parameter.webhook_secret.value
#   }

#   events = ["push"]
# }
# resource "aws_codestarconnections_connection" "example" {
#   name          = "example-connection"
#   provider_type = "GitHub"
# }

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.tags["projectname"]}-${var.tags["env"]}-backend-pipeline"
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = var.s3_bucket_acl
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}