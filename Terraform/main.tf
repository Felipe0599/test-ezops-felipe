provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

#Criar o bucket S3
resource "aws_s3_bucket" "terraform_state" {
  bucket = "test-felipe-terraform-state"

  
  tags = {
    Name        = "Terraform State Bucket Test Felipe"
    Environment = var.environment
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "test-felipe-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "test-felipe-terraform-locks"
    encrypt        = true
    acl            = "private"
  }
}

#Criar a tabela DynamoDB
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "test-felipe-terraform-locks"  
  billing_mode = "PAY_PER_REQUEST"  
  hash_key     = "LockID"  
    
  attribute {    
    name = "LockID"
    type = "S"  
  }  
} 