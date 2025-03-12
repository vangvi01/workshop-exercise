variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
}

variable "namespace" {
  description = "Namespace to create the service account"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the DynamoDB table"
  type        = string
}
