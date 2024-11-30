# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Configure backend for remote state storage
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket" 
    key            = "terraform/remote/state"     
    region         = "us-west-2"                  
    dynamodb_table = "terraform-lock"             
  }
}

# Resource: EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}

# Resource: S3 bucket for remote state
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "my-terraform-state-bucket" 
  acl    = "private"
}

# Resource: DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_lock_table" {
  name         = "terraform-lock"  # Update with your table name
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"
}
