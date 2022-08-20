data "aws_s3_bucket" "backend-bucket" {
  bucket = "main-backend-state-bucket"
}

# Resource block to create S3 bucket objects(folders.)
resource "aws_s3_bucket_object" "main-object" {
  for_each = toset(var.bucket_folders)

  bucket = data.aws_s3_bucket.backend-bucket.id
  key    = each.value
}
