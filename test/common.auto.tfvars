region   = "eu-west-2"
org      = "myorg"
app      = "threetier"
env      = "dev"
vpc_cidr = "10.0.0.0/16"
availability_zones = {
  "eu-west-2a" = "eu-west-2a"
  "eu-west-2b" = "eu-west-2b"
  "eu-west-2c" = "eu-west-2c"
}
public_subnet_cidrs = {
  "eu-west-2a" = "10.0.0.0/23"
  "eu-west-2b" = "10.0.2.0/23"
  "eu-west-2c" = "10.0.4.0/23"
}
private_subnet_cidrs = {
  "eu-west-2a" = "10.0.6.0/23"
  "eu-west-2b" = "10.0.8.0/23"
  "eu-west-2c" = "10.0.10.0/23"
}
database_subnet_cidrs = {
  "eu-west-2a" = "10.0.12.0/23"
  "eu-west-2b" = "10.0.14.0/23"
  "eu-west-2c" = "10.0.16.0/23"
}


