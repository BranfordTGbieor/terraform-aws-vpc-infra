variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "vpc_name" {
  description = "The VPC name for resource naming"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}
