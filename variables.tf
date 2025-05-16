variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "org" {
  description = "Organization name for resource tagging"
  type        = string
}

variable "app" {
  description = "Application name for resource tagging"
  type        = string
}

variable "env" {
  description = "Environment name for resource placement"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Map of availability zones with AZ names as keys and values"
  type        = map(string)
}

variable "public_subnet_cidrs" {
  description = "Map of public subnet CIDR blocks with availability zones as keys"
  type        = map(string)
}

variable "private_subnet_cidrs" {
  description = "Map of private subnet CIDR blocks with availability zones as keys"
  type        = map(string)
}

variable "database_subnet_cidrs" {
  description = "Map of database subnet CIDR blocks with availability zones as keys"
  type        = map(string)
}
