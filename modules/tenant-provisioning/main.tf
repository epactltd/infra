locals {
  tenant_bucket_prefix = var.tenant_bucket_prefix != "" ? var.tenant_bucket_prefix : "${var.project_name}-tenant-"
  function_name        = "${var.project_name}-${var.environment}-tenant-provisioner"
}

# ============================================================================
# EventBridge Event Bus (custom bus for application events)
# ============================================================================

resource "aws_cloudwatch_event_bus" "app" {
  name = "${var.project_name}-${var.environment}-app-events"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-app-events"
  })
}

# ============================================================================
# Lambda Function for Tenant Provisioning
# ============================================================================

data "archive_file" "provisioner_lambda" {
  type        = "zip"
  output_path = "${path.module}/provisioner_lambda.zip"

  source {
    content  = file("${path.module}/lambda/provisioner.py")
    filename = "provisioner.py"
  }
}

resource "aws_lambda_function" "provisioner" {
  function_name = local.function_name
  role          = aws_iam_role.provisioner_lambda.arn
  runtime       = "python3.11"
  handler       = "provisioner.lambda_handler"
  filename      = data.archive_file.provisioner_lambda.output_path
  timeout       = 60
  memory_size   = 256

  source_code_hash = data.archive_file.provisioner_lambda.output_base64sha256

  environment {
    variables = {
      TENANT_BUCKET_PREFIX    = local.tenant_bucket_prefix
      ENVIRONMENT             = var.environment
      REGION                  = var.region
      API_CALLBACK_URL        = var.api_callback_url
      API_CALLBACK_SECRET_ARN = var.api_callback_secret_arn
    }
  }

  tags = merge(var.tags, {
    Name = local.function_name
  })
}

resource "aws_cloudwatch_log_group" "provisioner_lambda" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 30

  tags = var.tags
}

# ============================================================================
# IAM Role for Provisioner Lambda
# ============================================================================

resource "aws_iam_role" "provisioner_lambda" {
  name = "${var.project_name}-${var.environment}-tenant-provisioner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "provisioner_lambda" {
  name = "${var.project_name}-${var.environment}-tenant-provisioner-policy"
  role = aws_iam_role.provisioner_lambda.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # CloudWatch Logs
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.region}:*:log-group:/aws/lambda/${local.function_name}:*"
      },
      # S3 Bucket Creation and Configuration
      {
        Effect = "Allow",
        Action = [
          "s3:CreateBucket",
          "s3:PutBucketPolicy",
          "s3:PutBucketVersioning",
          "s3:PutEncryptionConfiguration",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutLifecycleConfiguration",
          "s3:PutBucketNotification",
          "s3:PutBucketTagging",
          "s3:GetBucketLocation",
          "s3:HeadBucket"
        ],
        Resource = "arn:aws:s3:::${local.tenant_bucket_prefix}*"
      },
      # S3 Bucket Deletion (for tenant deletion)
      {
        Effect = "Allow",
        Action = [
          "s3:DeleteBucket",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:ListBucketVersions"
        ],
        Resource = [
          "arn:aws:s3:::${local.tenant_bucket_prefix}*",
          "arn:aws:s3:::${local.tenant_bucket_prefix}*/*"
        ]
      },
      # Secrets Manager for API callback token
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = var.api_callback_secret_arn
      }
    ]
  })
}

# ============================================================================
# EventBridge Rules
# ============================================================================

# Rule for TenantCreated event
resource "aws_cloudwatch_event_rule" "tenant_created" {
  name           = "${var.project_name}-${var.environment}-tenant-created"
  description    = "Trigger provisioning when a tenant is created"
  event_bus_name = aws_cloudwatch_event_bus.app.name

  event_pattern = jsonencode({
    source      = ["${var.project_name}.hq"],
    detail-type = ["TenantCreated"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "tenant_created" {
  rule           = aws_cloudwatch_event_rule.tenant_created.name
  event_bus_name = aws_cloudwatch_event_bus.app.name
  target_id      = "provisioner-lambda"
  arn            = aws_lambda_function.provisioner.arn
}

resource "aws_lambda_permission" "tenant_created" {
  statement_id  = "AllowExecutionFromEventBridgeTenantCreated"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.provisioner.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.tenant_created.arn
}

# Rule for TenantDeleted event
resource "aws_cloudwatch_event_rule" "tenant_deleted" {
  name           = "${var.project_name}-${var.environment}-tenant-deleted"
  description    = "Trigger cleanup when a tenant is deleted"
  event_bus_name = aws_cloudwatch_event_bus.app.name

  event_pattern = jsonencode({
    source      = ["${var.project_name}.hq"],
    detail-type = ["TenantDeleted"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "tenant_deleted" {
  rule           = aws_cloudwatch_event_rule.tenant_deleted.name
  event_bus_name = aws_cloudwatch_event_bus.app.name
  target_id      = "provisioner-lambda"
  arn            = aws_lambda_function.provisioner.arn
}

resource "aws_lambda_permission" "tenant_deleted" {
  statement_id  = "AllowExecutionFromEventBridgeTenantDeleted"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.provisioner.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.tenant_deleted.arn
}

# ============================================================================
# IAM Policy for Application to Publish Events
# ============================================================================

resource "aws_iam_policy" "eventbridge_publisher" {
  name        = "${var.project_name}-${var.environment}-eventbridge-publisher"
  description = "Allows application to publish events to EventBridge"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "events:PutEvents"
        ],
        Resource = aws_cloudwatch_event_bus.app.arn
      }
    ]
  })

  tags = var.tags
}

