
variable "region" {
  description = "The AWS region to deploy the DynamoDB table"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "read_capacity" {
  description = "Read capacity units for the table"
  type        = number
}

variable "write_capacity" {
  description = "Write capacity units for the table"
  type        = number
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery for the DynamoDB table"
  type        = bool

}



