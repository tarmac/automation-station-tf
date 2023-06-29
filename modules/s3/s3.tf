resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.tags["projectname"]}-${var.s3_bucket_name}-${var.tags["env"]}"
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = var.s3_bucket_acl
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  policy = data.aws_iam_policy_document.automation_station_s3_access.json
}

variable "aws_acc_id" {
  type = string
}

variable "cloudfront_distribution_arn" {
  description = "Cloudfront distribution arn"
  type        = string
  default     = ""
}

