# Dynamodb table to use for terraform state locking.
resource "aws_dynamodb_table" "main-terraformstatelock" {
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  name           = var.table_name
  read_capacity  = var.read_capacity
  stream_enabled = var.stream_enabled
  tags           = {}
  tags_all       = {}
  write_capacity = var.write_capacity

  attribute {
    name = var.attribute_name
    type = var.attribute_type
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  timeouts {}

  lifecycle {
    prevent_destroy = false
  }

}
