module "vpc" {
  source = "../"

  region                = var.region
  org                   = var.org
  app                   = var.app
  env                   = "dev"
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
}
