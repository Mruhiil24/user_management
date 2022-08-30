terraform {
  backend "s3" {
    bucket = "audit-tools-terraform"
    region = "us-east-1"
    key    = "terraform/states/terraform.tfstate"
  }
}