terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform_Demo"
  }
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "Terraform_1"
  acl    = "private"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-dynamodb1"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
terraform {
  backend "s3" {
    bucket         = "Terraform_1"
    key            = "terraform/statefile.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-dynamodb1"
  }
}
