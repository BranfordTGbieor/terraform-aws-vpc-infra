# AWS VPC Infrastructure with Terraform

This project provides a modular and reusable Terraform configuration for creating a production-grade AWS VPC infrastructure with public and private subnets, NAT Gateway, and EC2 instances.

## Architecture

The infrastructure includes:
- VPC with public and private subnets across multiple availability zones
- Internet Gateway for public subnet connectivity
- NAT Gateway for private subnet internet access
- Security groups for EC2 instances
- Route tables for subnet routing
- EC2 instances in both public and private subnets

![Architecture Diagram](assets/architectural_diagram.png)

## Project Structure

```
aws-vpc-terraform/
│── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── subnets/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── nat-gateway/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── security-groups/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │
│── assets/
│   └── architectural_diagram.png
│── scripts/
│   └── diagram.py
│── main.tf
│── variables.tf
│── outputs.tf
│── terraform.tfvars
│── backend.tf
│── README.md
```

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate credentials
- Python 3.x (for diagram generation)

## Features

- **Modular Design**: Each AWS component is encapsulated in its own module
- **High Availability**: Resources distributed across multiple availability zones
- **Security Best Practices**: 
  - Private subnets for sensitive resources
  - NAT Gateway for controlled internet access
  - Security groups with minimal required access
- **Cost Optimization**:
  - Single NAT Gateway for private subnets
  - Configurable instance types
  - Optional public IP association
- **Maintainability**:
  - Consistent naming convention
  - Comprehensive tagging
  - Reusable modules

## Configuration

### Required Variables

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}
```

### Optional Variables

```hcl
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

variable "associate_public_ip_address" {
  description = "Whether to associate public IP with private instances"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
```

## Deployment

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the planned changes:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Outputs

The configuration provides the following outputs:
- VPC ID
- Public and private subnet IDs
- NAT Gateway ID
- Security group IDs
- EC2 instance IDs and public IPs

## Best Practices

1. **State Management**:
   - Use remote state storage
   - Enable state locking
   - Implement state file encryption

2. **Security**:
   - Use private subnets for sensitive resources
   - Implement least privilege security groups
   - Enable VPC flow logs
   - Use AWS KMS for encryption

3. **Cost Management**:
   - Monitor NAT Gateway costs
   - Use appropriate instance types
   - Implement auto-scaling where needed

4. **Maintenance**:
   - Regular security updates
   - Cost optimization reviews
   - Performance monitoring

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository.

