variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs to create mount targets"
}

variable "app_sg_id" {
  type        = string
  description = "Security group ID of app servers"
}

