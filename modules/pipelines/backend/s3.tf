resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.tags["projectname"]}-${var.tags["env"]}-backend-pipeline"
  acl    = "private"
}