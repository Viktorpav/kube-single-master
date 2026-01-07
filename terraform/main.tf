terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  config = yamldecode(file("${path.module}/vars/common.yml"))

  # Extract variables
  project_name   = local.config.project_name
  aws_region     = local.config.aws_region
  s3_bucket_name = local.config.longhorn_s3_bucket
  retention_days = local.config.backup_retention_days
}

provider "aws" {
  region = local.aws_region
}

# S3 Bucket for Longhorn backups
resource "aws_s3_bucket" "longhorn_backups" {
  bucket = local.s3_bucket_name

  tags = {
    Name        = "Longhorn Backups"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Lifecycle rule - auto-delete old backups
resource "aws_s3_bucket_lifecycle_configuration" "longhorn_backups" {
  bucket = aws_s3_bucket.longhorn_backups.id

  rule {
    id     = "delete-old-backups"
    status = "Enabled"

    # Add this filter block to fix the warning
    filter {
      prefix = "" # Apply to all objects
    }

    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }

    expiration {
      days = local.retention_days
    }

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "longhorn_backups" {
  bucket = aws_s3_bucket.longhorn_backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
