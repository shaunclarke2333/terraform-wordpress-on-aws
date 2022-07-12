# S3 bucket that holds state file.
resource "aws_s3_bucket" "main-s3bucket" {
  bucket        = var.bucket
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = var.bucket_key_enabled

      apply_server_side_encryption_by_default {
        sse_algorithm = var.algorithm
      }
    }
  }

  versioning {
    enabled    = var.versioning_enabled
    mfa_delete = var.versioning_mfa_delete
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Resource block to create S3 bucket objects(folders)
resource "aws_s3_bucket_object" "main-object" {
  for_each = toset(var.bucket_folders)

  bucket                 = aws_s3_bucket.main-s3bucket.bucket
  key                    = each.value
  server_side_encryption = var.server_side_encryption
}
