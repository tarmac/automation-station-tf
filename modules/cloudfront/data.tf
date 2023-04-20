data "aws_acm_certificate" "automation_station" {
  domain   = "*.usetrace.com"
  statuses = ["ISSUED"]
}
