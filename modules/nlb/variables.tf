variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the NLB"
  type        = list(string)
}

variable "target_group_port" {
  description = "Port to forward traffic to (app server port)"
  type        = number
  default     = 8080
}

variable "target_group_protocol" {
  description = "Protocol for target group"
  type        = string
  default     = "TCP"
}

variable "asg_name" {
  description = "Name of the ASG to register as NLB target group target"
  type        = string
}

