variable "name_prefix" {
  description = "Name prefix for tagging"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "allow_ssh_from" {
  description = "CIDRs allowed to SSH into EC2"
  type        = list(string)
  default     = ["0.0.0.0/0"] # You may want to restrict this
}

variable "owner" {
  type        = string
  description = "Owner tag"
}

variable "project" {
  type        = string
  description = "Project tag"
}
