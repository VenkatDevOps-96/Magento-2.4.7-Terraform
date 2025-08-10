variable "launch_template_id" {
  description = "ID of the Launch Template"
  type        = string
}

variable "launch_template_version" {
  description = "Launch template version to use"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ASG"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "target_group_arns" {
  description = "List of NLB target group ARNs to attach (optional)"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "Type of health check (EC2 or ELB)"
  type        = string
  default     = "EC2"
}

