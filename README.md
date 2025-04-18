# AWS VPC Infrastructure with Terraform 🚀

This project provides a modular and reusable Terraform configuration for creating a production-grade AWS VPC infrastructure with high availability and security best practices. 🛡️

## Architecture 🏗️

This infrastructure deploys a production-grade, highly available VPC setup across multiple availability zones. Key components include:

- 🌐 VPC spanning multiple AZs
- 🌍 Public subnets for internet-facing services
- 🔒 Private subnets for internal resources
- 🔄 Route tables with proper subnet associations
- 🛡️ Layered security groups with least-privilege access
- 🌐 Internet Gateway for public subnet access
- 🔀 NAT Gateway for private subnet internet access
- ⚖️ Application Load Balancer for traffic distribution
- 🚀 Auto Scaling Group for application scalability
- 💾 Multi-AZ RDS deployment for high availability

![Architecture Diagram](assets/architectural_diagram.png)

## Project Structure 📁

```
aws-vpc-terraform/
│── modules/
│   ├── vpc/               # VPC configuration
│   ├── subnets/          # Public and private subnets
│   ├── nat-gateway/      # NAT Gateway for private subnets
│   ├── security-groups/  # Security group definitions
│   ├── ec2/             # EC2 instance configuration
│   ├── alb/             # Application Load Balancer setup
│   ├── autoscaling/     # Auto Scaling Group configuration
│   └── rds/             # RDS Multi-AZ setup
│── assets/
│── main.tf              # Main configuration
│── variables.tf         # Variable definitions
│── outputs.tf           # Output definitions
│── terraform.tfvars     # Variable values
└── README.md
```

## Prerequisites 📋

- 🛠️ Terraform >= 1.0.0
- 🔑 AWS CLI configured with appropriate credentials
- 🐍 Python 3.x (for diagram generation)

## Features ✨

- **Modular Design** 🧩
  - Each AWS component is encapsulated in its own module
  - Easy to customize and extend

- **High Availability** 🔄
  - Resources distributed across multiple AZs
  - Multi-AZ RDS deployment
  - Load balancing with ALB

- **Security Best Practices** 🛡️
  - Private subnets for sensitive resources
  - Layered security groups
  - Controlled internet access via NAT Gateway

- **Scalability** 📈
  - Auto Scaling Group for EC2 instances
  - Load balancing across multiple AZs
  - Easily adjustable capacity

- **Cost Optimization** 💰
  - Single NAT Gateway for cost efficiency
  - Configurable instance types
  - Optional features for development environments

## Quick Start 🚀

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

## Key Components 🔑

### Application Load Balancer 🌐
- Distributes traffic across multiple AZs
- Health checks for application instances
- HTTP/HTTPS listener support

### Auto Scaling Group 📈
- Maintains desired capacity across AZs
- Automatic scaling based on demand
- Integration with ALB for load distribution

### RDS Multi-AZ 💾
- Primary and standby instances
- Automatic failover capability
- Backup and recovery features

## Cleanup 🧹

To destroy the infrastructure:
```bash
terraform destroy
```

## Contributing 🤝

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Support 💬

For support, please open an issue in the GitHub repository.

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

