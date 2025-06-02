variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ElastiCache (must be in private subnets)"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group to attach to ElastiCache"
  type        = string
}

variable "node_type" {
  description = "ElastiCache instance type"
  type        = string
}

variable "num_shards" {
  description = "Number of node groups (shards) in the cluster"
  type        = number
}

variable "replicas_per_shard" {
  description = "Number of replicas per shard"
  type        = number
}

variable "owner" {
  description = "Owner tag"
  type        = string
}

variable "project" {
  description = "Project tag"
  type        = string
}
