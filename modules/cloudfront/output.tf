output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.automation_station_distribution.arn
}

output "aws_acm_certificate_arn" {
  value = data.aws_acm_certificate.automation_station.arn
}