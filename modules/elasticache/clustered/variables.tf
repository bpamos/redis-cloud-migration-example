variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for ElastiCache cluster"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the cluster"
  type        = string
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.r6g.large"
}

variable "num_shards" {
  description = "Number of Redis shards"
  type        = number
  default     = 2
}

variable "replicas_per_shard" {
  description = "Number of replicas per shard"
  type        = number
  default     = 1
}

variable "owner" {
  type        = string
  description = "Owner tag"
}

variable "project" {
  type        = string
  description = "Project tag"
}

variable "replication_group_suffix" {
  description = "Suffix to make replication group ID unique"
  type        = string
}

