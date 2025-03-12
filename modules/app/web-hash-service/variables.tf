variable "create_namespace" {
  description = "Set to true to create the namespace if it does not exist"
  default     = true
  type        = bool
}
variable "namespace" {
  description = "App namespace "
  default     = "web-hash-service"
  type        = string
}

variable "image_config" {
  type = object({
    registry   = string
    repository = string
    tag        = string
  })
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
}

variable "iam_role_arn" {
  description = "Name of the iam role to assume identity for the pods"
  type        = string
}
