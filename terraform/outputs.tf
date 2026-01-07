output "s3_bucket_name" {
  description = "S3 bucket name for Longhorn backups"
  value       = aws_s3_bucket.longhorn_backups.id
}

output "backup_target_url" {
  description = "Full S3 backup target URL for Longhorn"
  value       = "s3://${aws_s3_bucket.longhorn_backups.id}@${local.aws_region}/"
}

output "aws_region" {
  description = "AWS region"
  value       = local.aws_region
}

output "config_source" {
  description = "Configuration loaded from"
  value       = "vars/common.yml"
}
