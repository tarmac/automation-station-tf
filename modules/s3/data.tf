data "aws_iam_policy_document" "automation_station_s3_access" {

  statement {
    sid = "PolicyForCloudFrontPrivateContent"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.tags["projectname"]}-${var.s3_bucket_name}-${var.tags["env"]}",
      "arn:aws:s3:::${var.tags["projectname"]}-${var.s3_bucket_name}-${var.tags["env"]}/*"
      

    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        var.cloudfront_distribution_arn
      ]
    }
  }
}
