variable "public_subnet_id" {
  description = "The ID of the public subnet to deploy the NAT Gateway in"
  type        = string
}

variable "vpc_name" {
  description = "The VPC name for naming resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
