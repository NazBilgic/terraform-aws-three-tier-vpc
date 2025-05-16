provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Org = var.org 
      App = var.app
      Env = var.env
      CreatedBy = "Terraform"
      Owner = "Naz Bilgic"
    }
  }
}