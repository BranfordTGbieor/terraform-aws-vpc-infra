# AWS VPC Terraform Mini Project

## Project Overview

This Terraform project provisions an **AWS Virtual Private Cloud (VPC)** with a high-availability architecture, featuring **public and private subnets across two availability zones (AZs)**. The setup ensures that resources in private subnets can access the internet securely via a **NAT Gateway**, while resources in public subnets have direct internet access through an **Internet Gateway**.

## Features

- **Highly Available VPC** with **4 subnets**
  - 2 Public Subnets (in different AZs)
  - 2 Private Subnets (in different AZs)
- **Internet Gateway (IGW)** for public internet access
- **NAT Gateway (NGW)** for secure outbound traffic from private subnets
- **Elastic IP (EIP)** for the NAT Gateway
- **Route Tables** with proper subnet associations
- **Security Groups** for controlled traffic flow
- **Optional VPC Endpoint for S3** to optimize data transfer from private instances
- **EC2 Instances** for testing purposes (1 Public, 1 Private)

## Directory Structure

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
│
│── envs/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── backend.tf
│   │
│   ├── prod/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── backend.tf
│
│── scripts/
│── README.md
```

## Flowchart Logic Diagram

![AWS VPC Architecture Diagram](/assets/aws_vpc_infra.png)

## Deployment Steps

### 1. Prerequisites

Ensure you have:

- AWS CLI installed and configured
- Terraform 0.13+ installed
- Proper IAM permissions for creating VPC and related resources

### 2. Clone the Repository

```
git clone https://github.com/your-repo/aws-vpc-terraform.git
cd aws-vpc-terraform
```

### 3. Initialize Terraform

```
terraform init
```

### 4. Plan Infrastructure Changes

```
terraform plan
```

### 5. Apply Terraform Configuration

```
terraform apply -auto-approve
```

### 6. Verify Resources

```
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc"
```

## Cleanup

To destroy all resources:

```
terraform destroy -auto-approve
```

## Best Practices Followed

- **Modular Terraform Code** for scalability and reuse
- **Remote State Management** using **S3 & DynamoDB (backend.tf)**
- **Least Privilege Access Control** via IAM roles & Security Groups
- **Multi-AZ Architecture** for high availability

---

This setup provides a robust **AWS VPC infrastructure** suitable for hosting applications with proper security, routing, and high availability considerations. 🚀

