variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instances"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group IDs for EC2 instances"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags for EC2 instances"
  type        = map(string)
  default     = {}
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data for EC2 instances"
  type        = string
  default     = ""
}
