resource "aws_cloudfront_distribution" "automation_station_distribution" {
  aliases             = var.tags == "dev" ? ["automation-station.dev.usetrace.com"] : ["automation-station.usetrace.com"]
  default_root_object = var.cloudfront_default_root_object
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200       
    response_page_path    = "/index.html" 
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods = ["GET","HEAD"]
    cached_methods  = ["GET","HEAD"]
    compress               = true
    target_origin_id       = var.tags == "prod" ? "${var.tags["projectname"]}-${var.s3_bucket_name}.s3-${var.region}.amazonaws.com" : "${var.tags["projectname"]}-${var.s3_bucket_name}-${var.tags["env"]}.s3-${var.region}.amazonaws.com"

    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = var.tags == "prod" ? "${var.tags["projectname"]}-${var.s3_bucket_name}.s3-${var.region}.amazonaws.com" : "${var.tags["projectname"]}-${var.s3_bucket_name}-${var.tags["env"]}.s3-${var.region}.amazonaws.com"
    origin_id           = var.tags == "prod" ? "${var.tags["projectname"]}-${var.s3_bucket_name}.s3-${var.region}.amazonaws.com" : "${var.tags["projectname"]}-${var.s3_bucket_name}-${var.tags["env"]}.s3-${var.region}.amazonaws.com"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_frontend.id
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.automation_station.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "s3_frontend" {
  name                              = var.tags == "dev" ? "internal-frontend-dev.s3-us-east-1.amazonaws.com" : "internal-frontend-${var.tags["env"]}.s3-us-east-1.amazonaws.com"
  description                       = "Cloudfront distribution for S3 frontend"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"

}
