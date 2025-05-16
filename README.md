# Terraform AWS 3-Tier VPC Module

This repository contains a Terraform module for provisioning a secure, scalable, and highly available 3-tier Virtual Private Cloud (VPC) infrastructure in AWS. It includes all essential networking components such as subnets, route tables, NAT gateways, security groups, and network ACLs—built using AWS best practices.

## Features

- VPC creation with customizable CIDR blocks  
- Public, private, and database subnets across multiple Availability Zones  
- Internet Gateway for public subnet internet access  
- NAT Gateways for private subnet internet access  
- Route Tables and automatic subnet associations  
- Network ACLs (NACLs) for subnet-level access control  
- Elastic IPs for NAT Gateways  
- Optional Reachability Analyzer for connectivity validation  
- Resource tagging for visibility and cost tracking  

## Prerequisites

- Terraform v1.0+
- AWS Provider v4.0+
- AWS CLI configured
- IAM permissions to create VPC resources

## Usage

```hcl
module "vpc" {
  source = "github.com/NazBilgic/terraform-aws-three-tier-vpc"

  region               = "eu-west-2"
  org                  = "myorg"
  app                  = "threetier"
  env                  = "dev"
  vpc_cidr             = "10.0.0.0/16"

  availability_zones = {
    eu-west-2a = "eu-west-2a"
    eu-west-2b = "eu-west-2b"
    eu-west-2c = "eu-west-2c"
  }

  public_subnet_cidrs = {
    eu-west-2a = "10.0.0.0/23"
    eu-west-2b = "10.0.2.0/23"
    eu-west-2c = "10.0.4.0/23"
  }

  private_subnet_cidrs = {
    eu-west-2a = "10.0.6.0/23"
    eu-west-2b = "10.0.8.0/23"
    eu-west-2c = "10.0.10.0/23"
  }

  database_subnet_cidrs = {
    eu-west-2a = "10.0.12.0/23"
    eu-west-2b = "10.0.14.0/23"
    eu-west-2c = "10.0.16.0/23"
  }

  enable_vpc_reachability_analyzer = false
}
```

## Input Variables

| Name                             | Description                                 | Type        | Required |
|----------------------------------|---------------------------------------------|-------------|----------|
| region                           | AWS region to deploy resources              | string      | yes      |
| org                              | Organization name for resource tagging      | string      | yes      |
| app                              | Application name for resource tagging       | string      | yes      |
| env                              | Environment name (e.g. dev, prod)           | string      | yes      |
| vpc_cidr                         | CIDR block for the VPC                      | string      | yes      |
| availability_zones               | Map of AZs for resource distribution        | map(string) | yes      |
| public_subnet_cidrs              | CIDRs for public subnets across AZs         | map(string) | yes      |
| private_subnet_cidrs             | CIDRs for private subnets across AZs        | map(string) | yes      |
| database_subnet_cidrs            | CIDRs for database subnets across AZs       | map(string) | yes      |
| enable_vpc_reachability_analyzer| (Optional) Enable Reachability Analyzer     | bool        | no       |

## Outputs

| Name                | Description                   |
|---------------------|-------------------------------|
| vpc_id              | ID of the created VPC         |
| public_subnet_ids   | List of public subnet IDs     |
| private_subnet_ids  | List of private subnet IDs    |
| database_subnet_ids | List of database subnet IDs   |
| nat_gateway_ids     | List of NAT Gateway IDs       |

## File Structure

```
TERRAFORM-AWS-THREE-TIER-VPC/
├── test/
│   ├── .terraform.lock.hcl
│   ├── common.auto.tfvars
│   ├── main.tf
│   ├── provider.tf
│   └── variables.tf
├── README.md
├── route_table.tf
├── sg.tf
├── subnets.tf
├── variables.tf
├── vpc.tf
├── eip.tf
├── igw.tf
├── nacl.tf
├── nat.tf
├── outputs.tf
├── provider.tf
```

## How to Deploy

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## Notes

- Public subnets are internet-facing via Internet Gateway  
- Private subnets route outbound traffic via NAT Gateway  
- Database subnets are isolated with no internet access  
- Network ACLs and Security Groups are created for each tier  
- Tags are added to all resources for visibility and cost tracking  
