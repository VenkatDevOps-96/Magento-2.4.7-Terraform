variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "varnish_target_ip" {
  description = "Private IP of varnish server"
  type        = string
}

variable "admin_target_ip" {
  description = "Private IP of admin server"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

