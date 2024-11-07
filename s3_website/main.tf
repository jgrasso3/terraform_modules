# Steps to setup a static website using an S3 bucket
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html#object-acl

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

resource "aws_s3_bucket" "aws-test" {
  bucket = "jgrasso1-${var.bucket-name}"
  tags = {
    Description = "Test setting up an angular app on AWS using Terreform"
  }
}

resource "aws_s3_bucket_ownership_controls" "aws-test" {
  bucket = aws_s3_bucket.aws-test.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_website_configuration" "aws-test" {
  bucket = aws_s3_bucket.aws-test.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "aws-test" {
  bucket = aws_s3_bucket.aws-test.id

  block_public_acls = var.block-public-access
  block_public_policy = var.block-public-access
  ignore_public_acls = var.block-public-access
  restrict_public_buckets = var.block-public-access
}

resource "aws_s3_bucket_policy" "aws-test" {
  bucket = aws_s3_bucket.aws-test.id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicReadGetObject",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.aws-test.id}/*"
      }
    ]
  }
  EOF
}

resource "aws_s3_object" "aws-test" {
  bucket = aws_s3_bucket.aws-test.id
  depends_on = [ aws_s3_bucket_ownership_controls.aws-test ]

  for_each = module.template_files.files
  key = each.key
  content_type = each.value.content_type
  source  = each.value.source_path
  content = each.value.content
}

# Gather all files in a dir and dynamically apply the right content type
module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = var.static-files
}
