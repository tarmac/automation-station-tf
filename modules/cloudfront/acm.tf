resource "aws_acm_certificate" "automation-station" {
  domain_name       = "*.automation-station.tarmac.io"
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}