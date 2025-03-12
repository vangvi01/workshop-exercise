
variable "dynamodb_config" {
  description = "Configuration settings for the DynamoDB table"
  type = object({
    region                        = string
    table_name                    = string
    read_capacity                 = number
    write_capacity                = number
    environment                   = string
    enable_point_in_time_recovery = bool
  })

}


variable "web_hash_service_config" {
  description = "Configuration settings for the DynamoDB table"
  type = object({
    create_namespace = optional(bool, true)
    namespace        = optional(string, "web_hash_service")
    image_config = object({
      registry   = string
      repository = string
      tag        = string
    })
  })

}

variable "pod_identity_config" {
  type = object({
    cluster_name         = string
    namespace            = string
    service_account_name = optional(string, "web-hash-service-svc")
  })
  description = "pod identity configuration"
}