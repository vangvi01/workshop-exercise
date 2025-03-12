

variable "cluster_name_prefix" {
  type        = string
  description = "Name of the k8s cluster prefix"
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string

  validation {
    condition     = contains(["1.29", "1.30", "1.31", "1.32"], var.cluster_version)
    error_message = "Invalid EKS cluster version. Valid values are: 1.29, 1.30, 1.31, 1.32."
  }
}

variable "region" {
  type        = string
  description = "AWS region to deploy the EKS cluster"

}
variable "environment" {
  type        = string
  description = "Lifecycle of the AWS resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC id to deploy the EKS cluster"

}
variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids to deploy the EKS cluster"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the cluster resource"
}

variable "node_group_name" {
  type        = string
  description = "Name of the node group"
}

variable "capacity_type" {
  type        = string
  description = "Capacity type of the node group"
  default     = "ON_DEMAND"
}

variable "instance_types" {
  type        = list(string)
  description = "Node Group Instance Types"
}

variable "scaling_config" {
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
  description = "values for desired, max and min size of the node group"
}

variable "update_config" {
  type = object({
    max_unavailable = number
  })
  default = {
    max_unavailable = 1
  }
  description = "values for max unavailable nodes during update"
}

variable "aws_lbc_namespace" {
  type        = string
  description = "Name of the AWS Load Balancer Controller namespace"
  default     = "kube-system"

}