data "aws_acm_certificate" "automation_station" {
  domain   = "*.automation-station.tarmac.io"
  statuses = ["ISSUED"]
}