variable "bastion_subnet_id" {
  description = "Subnet ID for the bastion host"
  type        = string
}

variable "varnish_subnet_id" {
  description = "Subnet ID for the varnish server"
  type        = string
}

variable "admin_subnet_id" {
  description = "Subnet ID for the admin server"
  type        = string
}

variable "key_name" {
  description = "SSH key name to access the instances"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instances"
  type        = string
}

variable "admin_ami_id" {
  description = "AMI ID to use for the admin EC2 instance"
  type        = string
}

variable "varnish_ami_id" {
  description = "AMI ID to use for the varnish EC2 instance"
  type = string
}

variable "bastion_instance_type" {
  description = "EC2 instance type for bastion"
  type        = string
  default     = "t2.micro"
}

variable "varnish_instance_type" {
  description = "EC2 instance type for varnish"
  type        = string
  default     = "t3.medium"
}

variable "admin_instance_type" {
  description = "EC2 instance type for admin"
  type        = string
  default     = "t3.medium"
}

variable "varnish_volume_size" {
  description = "EBS volume size for varnish instance"
  type        = number
  default     = 50
}

variable "admin_volume_size" {
  description = "EBS volume size for admin instance"
  type        = number
  default     = 100
}

variable "security_group_ids" {
  description = "Security groups to attach to the instances"
  type        = list(string)
}

