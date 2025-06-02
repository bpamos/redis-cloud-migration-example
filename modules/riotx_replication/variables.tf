variable "ec2_public_ip" {
  description = "The public IP address of the EC2 instance running RIOTX."
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the private SSH key used to access the RIOTX EC2 instance."
  type        = string
}

variable "elasticache_endpoint" {
  description = "Primary endpoint for the ElastiCache Redis (standalone) source."
  type        = string
}

variable "rediscloud_private_endpoint" {
  description = "Private endpoint for the Redis Cloud target database."
  type        = string
}

variable "rediscloud_password" {
  description = "Password for accessing the Redis Cloud database."
  type        = string
  sensitive   = true
}

variable "rediscloud_port" {
  description = "Port for the Redis Cloud database endpoint."
  type        = number
  default     = 13313
}
