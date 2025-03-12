output "dynamodb_table_name" {
  value = aws_dynamodb_table.message_hash_table.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.message_hash_table.arn
}