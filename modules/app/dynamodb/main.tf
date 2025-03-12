resource "aws_dynamodb_table" "message_hash_table" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "hash"

  attribute {
    name = "hash"
    type = "S"
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment
    Project     = "message-hash-service"
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }
}
