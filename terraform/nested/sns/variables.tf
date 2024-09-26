variable "part" {
  type    = string
}

variable "email" {
  description = "The email address to subscribe to the SNS topic"
  type    = string
}

variable "dlq_name" {
  type = string
}
