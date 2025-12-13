output "event_bus_name" {
  description = "Name of the EventBridge event bus"
  value       = aws_cloudwatch_event_bus.app.name
}

output "event_bus_arn" {
  description = "ARN of the EventBridge event bus"
  value       = aws_cloudwatch_event_bus.app.arn
}

output "lambda_function_name" {
  description = "Name of the provisioner Lambda function"
  value       = aws_lambda_function.provisioner.function_name
}

output "lambda_function_arn" {
  description = "ARN of the provisioner Lambda function"
  value       = aws_lambda_function.provisioner.arn
}

output "eventbridge_publisher_policy_arn" {
  description = "ARN of the IAM policy for publishing events"
  value       = aws_iam_policy.eventbridge_publisher.arn
}

output "tenant_bucket_prefix" {
  description = "Prefix used for tenant S3 buckets"
  value       = local.tenant_bucket_prefix
}

