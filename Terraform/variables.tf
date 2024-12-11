variable "aws_region" {
  type        = string
  description = "The AWS region to create resources in."
}

variable "aws_access_key_id" {
  type        = string
  description = "The AWS access key ID."
}

variable "aws_secret_access_key" {
  type        = string
  description = "The AWS secret access key."
}

variable "ec2_key_name" {
  description = "Name of the SSH key pair for EC2 instances"
  type        = string
}

variable "backend_port" {
  description = "external port to backend"
  type        = number
}

variable "aws_arn_role" {
  description = "The AWS ARN role"
  type        = string
}

variable "environment" {
  description = "The environment for the resources."
  type        = string
  default     = "dev"
}