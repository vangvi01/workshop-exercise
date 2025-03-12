terraform {
  backend "s3" {
    bucket         = "iac-terraform-state-management"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "iac-terraform-state-locks"
    encrypt        = true
  }
}