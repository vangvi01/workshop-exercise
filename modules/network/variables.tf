variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"

}

variable "tags" {
  type        = map(string)
  description = "Tags for the resources"
}

variable "enable_dns_support" {
  type        = bool
  description = "enable dns support"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostnames"

}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  type = object({
    private = list(string)
    public  = list(string)
  })
}


variable "cluster_name_prefix" {
  type        = string
  description = "Name of the k8s cluster prefix"
  default     = null
}

variable "environment" {
  type        = string
  description = "Environment or lifecycle for the resources"
}