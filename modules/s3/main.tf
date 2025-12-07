resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-${var.environment}-storage"

  tags = {
    Name = "${var.project_name}-${var.environment}-storage"
  }
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "archive-to-glacier"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "enforce_tls" {
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "${aws_s3_bucket.main.arn}",
          "${aws_s3_bucket.main.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# Tenant bucket malware scan pipeline (applies to buckets prefixed with tenant_bucket_prefix)
locals {
  tenant_bucket_prefix = var.tenant_bucket_prefix_override != "" ? var.tenant_bucket_prefix_override : "${var.project_name}-${var.environment}-tenant-"
}

data "archive_file" "scan_lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/scan_lambda.zip"

  source {
    content  = <<EOF
import boto3
import os

s3 = boto3.client("s3")

def lambda_handler(event, context):
    # STUB SCANNER: FAIL-SAFE MODE
    # In production, this MUST be replaced with a real scanner (e.g., ClamAV).
    # We DO NOT tag the object as clean here, enforcing the "Default Deny" bucket policy.
    for record in event.get("Records", []):
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]
        print(f"WARNING: Malware scanner is a stub. File s3://{bucket}/{key} will NOT be marked as clean.")
        # s3.put_object_tagging(...) <--- DISABLED FOR SECURITY
    return {"status": "stub_scanner_executed"}
EOF
    filename = "lambda_function.py"
  }
}

resource "aws_iam_role" "scan_lambda" {
  name = "${var.project_name}-${var.environment}-s3-scan-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "scan_lambda" {
  role = aws_iam_role.scan_lambda.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectTagging",
          "s3:PutObjectTagging"
        ],
        Resource = [
          "arn:aws:s3:::${local.tenant_bucket_prefix}*",
          "arn:aws:s3:::${local.tenant_bucket_prefix}*/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "scan" {
  function_name = "${var.project_name}-${var.environment}-s3-scan"
  role          = aws_iam_role.scan_lambda.arn
  runtime       = "python3.11"
  handler       = "lambda_function.lambda_handler"
  filename      = data.archive_file.scan_lambda_zip.output_path
  timeout       = 120

  environment {
    variables = {
      TENANT_BUCKET_PREFIX = local.tenant_bucket_prefix
    }
  }
}

resource "aws_cloudwatch_log_group" "scan_lambda" {
  name              = "/aws/lambda/${aws_lambda_function.scan.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_permission" "scan_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scan.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_object_created.arn
}

resource "aws_cloudwatch_event_rule" "s3_object_created" {
  name        = "${var.project_name}-${var.environment}-s3-object-created"
  description = "Invoke scanner for tenant buckets"

  event_pattern = jsonencode({
    "source": ["aws.s3"],
    "detail-type": ["Object Created"],
    "detail": {
      "bucket": {
        "name": [{ "prefix": local.tenant_bucket_prefix }]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "s3_object_created" {
  rule      = aws_cloudwatch_event_rule.s3_object_created.name
  target_id = "scan-lambda"
  arn       = aws_lambda_function.scan.arn
}

# IAM policy to let the HQ app create per-tenant buckets with baseline protections
resource "aws_iam_policy" "tenant_bucket_provisioner" {
  name = "${var.project_name}-${var.environment}-tenant-bucket-provisioner"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
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
          "s3:PutBucketTagging"
        ],
        Resource = [
          "arn:aws:s3:::${local.tenant_bucket_prefix}*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetBucketLocation",
          "s3:GetBucketPolicy"
        ],
        Resource = "arn:aws:s3:::${local.tenant_bucket_prefix}*"
      }
    ]
  })
}
