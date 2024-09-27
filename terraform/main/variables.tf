variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "run_version" {
  description = "A version identifier for naming resources"
  type = string
  default     = "6"  # You can change this default or set it at runtime
}

variable "email" {
  description = "The email address to subscribe to the SNS topic"
  type    = string
}
