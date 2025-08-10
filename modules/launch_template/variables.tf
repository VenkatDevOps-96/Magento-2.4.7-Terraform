variable "ami_id" {
  description = "AMI ID for Magento app servers"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "volume_size" {
  description = "Size of root EBS volume in GB"
  type        = number
  default     = 100
}

variable "iam_instance_profile" {
  description = "IAM instance profile name (optional)"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "Optional user data script (will be base64 encoded)"
  type        = string
  default     = ""
}

