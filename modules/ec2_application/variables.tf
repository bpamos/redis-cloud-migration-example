variable "name_prefix" {
  type = string
}

variable "ami_id" {
  description = "AMI ID to use for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the app node"
  type        = string
  default     = "t2.xlarge"
}

variable "subnet_id" {
  description = "Subnet to launch the EC2 instance into"
  type        = string
}

variable "security_group_id" {
  description = "Security group for EC2"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "owner" {
  type = string
}

variable "project" {
  type = string
}

variable "ssh_private_key_path" {
  description = "Path to private key file for SSH access"
  type        = string
}
