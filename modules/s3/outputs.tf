output "bucket_id" {
  value = aws_s3_bucket.main.id
}

output "bucket_arn" {
  value = aws_s3_bucket.main.arn
}

output "tenant_bucket_prefix" {
  value = local.tenant_bucket_prefix
}

output "tenant_bucket_provisioner_policy_arn" {
  value = aws_iam_policy.tenant_bucket_provisioner.arn
}

output "tenant_bucket_data_access_policy_arn" {
  value = aws_iam_policy.tenant_bucket_data_access.arn
}

output "scan_lambda_arn" {
  value = aws_lambda_function.scan.arn
}
