output "website-url" {
  value = aws_s3_bucket_website_configuration.aws-test.website_endpoint
}