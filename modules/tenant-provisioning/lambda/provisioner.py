"""
Tenant S3 Bucket Provisioner Lambda

This Lambda function handles tenant provisioning events from EventBridge:
- TenantCreated: Creates an S3 bucket with secure configuration
- TenantDeleted: Deletes the S3 bucket and all objects

The Lambda calls back to the API to update the tenant's configuration.
"""

import boto3
import json
import os
import urllib.request
import urllib.error
from typing import Any

# Initialize AWS clients
s3 = boto3.client("s3")
secretsmanager = boto3.client("secretsmanager")

# Environment variables
TENANT_BUCKET_PREFIX = os.environ.get("TENANT_BUCKET_PREFIX", "envelope-tenant-")
ENVIRONMENT = os.environ.get("ENVIRONMENT", "prod")
REGION = os.environ.get("REGION", "eu-west-2")
API_CALLBACK_URL = os.environ.get("API_CALLBACK_URL", "")
API_CALLBACK_SECRET_ARN = os.environ.get("API_CALLBACK_SECRET_ARN", "")


def get_api_token() -> str:
    """Retrieve API callback token from Secrets Manager."""
    if not API_CALLBACK_SECRET_ARN:
        raise ValueError("API_CALLBACK_SECRET_ARN not configured")
    
    response = secretsmanager.get_secret_value(SecretId=API_CALLBACK_SECRET_ARN)
    secret = json.loads(response["SecretString"])
    return secret.get("token", "")


def call_api(tenant_id: str, action: str, data: dict) -> bool:
    """Call the API to update tenant configuration."""
    if not API_CALLBACK_URL:
        print(f"Warning: API_CALLBACK_URL not configured, skipping callback")
        return False
    
    url = f"{API_CALLBACK_URL}/api/internal/tenants/{tenant_id}/provisioning"
    token = get_api_token()
    
    payload = json.dumps({
        "action": action,
        "data": data
    }).encode("utf-8")
    
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {token}",
        "X-Provisioner-Source": "lambda"
    }
    
    req = urllib.request.Request(url, data=payload, headers=headers, method="POST")
    
    try:
        with urllib.request.urlopen(req, timeout=30) as response:
            result = response.read().decode("utf-8")
            print(f"API callback success: {response.status} - {result}")
            return True
    except urllib.error.HTTPError as e:
        print(f"API callback failed: {e.code} - {e.read().decode('utf-8')}")
        return False
    except Exception as e:
        print(f"API callback error: {str(e)}")
        return False


def create_bucket(tenant_id: str) -> dict:
    """Create an S3 bucket for a tenant with secure configuration."""
    bucket_name = f"{TENANT_BUCKET_PREFIX}{tenant_id}-{ENVIRONMENT}"
    
    print(f"Creating bucket: {bucket_name} in region: {REGION}")
    
    # Check if bucket already exists
    try:
        s3.head_bucket(Bucket=bucket_name)
        print(f"Bucket {bucket_name} already exists")
        return {"bucket": bucket_name, "region": REGION, "status": "exists"}
    except s3.exceptions.ClientError as e:
        if e.response["Error"]["Code"] != "404":
            raise
    
    # Create bucket
    create_params = {"Bucket": bucket_name}
    if REGION != "us-east-1":
        create_params["CreateBucketConfiguration"] = {"LocationConstraint": REGION}
    
    s3.create_bucket(**create_params)
    print(f"Bucket created: {bucket_name}")
    
    # Wait for bucket to exist
    waiter = s3.get_waiter("bucket_exists")
    waiter.wait(Bucket=bucket_name)
    
    # Enable versioning
    s3.put_bucket_versioning(
        Bucket=bucket_name,
        VersioningConfiguration={"Status": "Enabled"}
    )
    print("Versioning enabled")
    
    # Enable server-side encryption (AES-256)
    s3.put_bucket_encryption(
        Bucket=bucket_name,
        ServerSideEncryptionConfiguration={
            "Rules": [{
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }]
        }
    )
    print("Encryption enabled")
    
    # Block all public access
    s3.put_public_access_block(
        Bucket=bucket_name,
        PublicAccessBlockConfiguration={
            "BlockPublicAcls": True,
            "IgnorePublicAcls": True,
            "BlockPublicPolicy": True,
            "RestrictPublicBuckets": True
        }
    )
    print("Public access blocked")
    
    # Add lifecycle rule for archiving old objects
    s3.put_bucket_lifecycle_configuration(
        Bucket=bucket_name,
        LifecycleConfiguration={
            "Rules": [{
                "ID": "archive-to-glacier",
                "Status": "Enabled",
                "Filter": {"Prefix": ""},
                "Transitions": [{
                    "Days": 90,
                    "StorageClass": "GLACIER"
                }]
            }]
        }
    )
    print("Lifecycle rules configured")
    
    # Enforce TLS
    bucket_policy = {
        "Version": "2012-10-17",
        "Statement": [{
            "Sid": "DenyInsecureTransport",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                f"arn:aws:s3:::{bucket_name}",
                f"arn:aws:s3:::{bucket_name}/*"
            ],
            "Condition": {
                "Bool": {"aws:SecureTransport": "false"}
            }
        }]
    }
    s3.put_bucket_policy(Bucket=bucket_name, Policy=json.dumps(bucket_policy))
    print("TLS enforcement policy applied")
    
    # Tag the bucket
    s3.put_bucket_tagging(
        Bucket=bucket_name,
        Tagging={
            "TagSet": [
                {"Key": "TenantId", "Value": str(tenant_id)},
                {"Key": "Environment", "Value": ENVIRONMENT},
                {"Key": "ManagedBy", "Value": "tenant-provisioner-lambda"},
                {"Key": "Project", "Value": "envelope"}
            ]
        }
    )
    print("Tags applied")
    
    return {"bucket": bucket_name, "region": REGION, "status": "created"}


def delete_bucket(tenant_id: str) -> dict:
    """Delete an S3 bucket and all its contents."""
    bucket_name = f"{TENANT_BUCKET_PREFIX}{tenant_id}-{ENVIRONMENT}"
    
    print(f"Deleting bucket: {bucket_name}")
    
    # Check if bucket exists
    try:
        s3.head_bucket(Bucket=bucket_name)
    except s3.exceptions.ClientError as e:
        if e.response["Error"]["Code"] == "404":
            print(f"Bucket {bucket_name} does not exist")
            return {"bucket": bucket_name, "status": "not_found"}
        raise
    
    # Delete all objects and versions
    paginator = s3.get_paginator("list_object_versions")
    for page in paginator.paginate(Bucket=bucket_name):
        objects_to_delete = []
        
        for version in page.get("Versions", []):
            objects_to_delete.append({
                "Key": version["Key"],
                "VersionId": version["VersionId"]
            })
        
        for marker in page.get("DeleteMarkers", []):
            objects_to_delete.append({
                "Key": marker["Key"],
                "VersionId": marker["VersionId"]
            })
        
        if objects_to_delete:
            s3.delete_objects(
                Bucket=bucket_name,
                Delete={"Objects": objects_to_delete, "Quiet": True}
            )
            print(f"Deleted {len(objects_to_delete)} objects/versions")
    
    # Delete the bucket
    s3.delete_bucket(Bucket=bucket_name)
    print(f"Bucket {bucket_name} deleted")
    
    return {"bucket": bucket_name, "status": "deleted"}


def lambda_handler(event: dict, context: Any) -> dict:
    """
    Main Lambda handler for EventBridge events.
    
    Event structure:
    {
        "source": "envelope.hq",
        "detail-type": "TenantCreated" | "TenantDeleted",
        "detail": {
            "tenant_id": "123",
            "subdomain": "acme",
            ...
        }
    }
    """
    print(f"Received event: {json.dumps(event)}")
    
    detail_type = event.get("detail-type", "")
    detail = event.get("detail", {})
    tenant_id = str(detail.get("tenant_id", ""))
    
    if not tenant_id:
        return {"status": "error", "message": "tenant_id is required"}
    
    try:
        if detail_type == "TenantCreated":
            # Create bucket
            result = create_bucket(tenant_id)
            
            # Update tenant via API callback
            if result["status"] in ("created", "exists"):
                call_api(tenant_id, "bucket_created", {
                    "bucket": result["bucket"],
                    "region": result["region"]
                })
            
            return {"status": "success", "action": "create", "result": result}
        
        elif detail_type == "TenantDeleted":
            # Delete bucket
            result = delete_bucket(tenant_id)
            
            # Update tenant via API callback
            call_api(tenant_id, "bucket_deleted", {
                "bucket": result.get("bucket", "")
            })
            
            return {"status": "success", "action": "delete", "result": result}
        
        else:
            return {"status": "error", "message": f"Unknown detail-type: {detail_type}"}
    
    except Exception as e:
        print(f"Error: {str(e)}")
        
        # Try to update tenant with error status
        try:
            call_api(tenant_id, "bucket_error", {
                "error": str(e)
            })
        except:
            pass
        
        raise

