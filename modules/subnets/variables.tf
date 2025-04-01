variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The VPC name to use in naming subnets"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
