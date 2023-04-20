variable "cloudfront_default_root_object" {
  type = string
}
variable "region" {
  type = string
}
variable "tags" {
  type = map(any)
}
variable "s3_bucket_name" {
  type = string
}
variable "web_acl_arn" {
  type = string
}