variable "rediscloud_api_key" {
  description = "Redis Cloud API key"
  type        = string
}

variable "rediscloud_secret_key" {
  description = "Redis Cloud API secret"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the Terraform AWS provider"
  type        = string
  default     = "us-west-2"
}

variable "credit_card_type" {
  description = "Credit card type to use for Redis Cloud payment (e.g., Visa, Mastercard)"
  type        = string
  default     = "Visa"
}

variable "credit_card_last_four" {
  description = "Last four digits of the credit card to use for Redis Cloud subscription"
  type        = string
}

variable "subscription_name" {
  description = "Name for the Redis Cloud subscription"
  type        = string
  default     = "my-redis-subscription"
}

variable "memory_storage" {
  description = "Memory storage option (e.g., ram, ram-and-flash)"
  type        = string
  default     = "ram"
}

variable "redis_version" {
  description = "Version of Redis to use (e.g., 7.2)"
  type        = string
  default     = "7.2"
}

variable "cloud_provider" {
  description = "Cloud provider to use for Redis Cloud (AWS or GCP)"
  type        = string
  default     = "AWS"
}

variable "rediscloud_region" {
  description = "Cloud provider region for Redis deployment"
  type        = string
  default     = "us-west-2"
}

variable "multi_az" {
  description = "Deploy Redis across multiple availability zones"
  type        = bool
  default     = true
}

variable "networking_deployment_cidr" {
  description = "CIDR block used for Redis Cloud networking deployment"
  type        = string
  default     = "10.42.0.0/24"
}

variable "preferred_azs" {
  description = "Preferred availability zones for Redis Cloud deployment"
  type        = list(string)
  default     = ["usw2-az1", "usw2-az2", "usw2-az3"]
}

variable "dataset_size_in_gb" {
  description = "Size of the dataset in GB"
  type        = number
  default     = 1
}

variable "database_quantity" {
  description = "Number of databases to create in the subscription"
  type        = number
  default     = 1
}

variable "replication" {
  description = "Whether to enable replication"
  type        = bool
  default     = true
}

variable "throughput_by" {
  description = "Throughput measurement method (e.g., operations-per-second)"
  type        = string
  default     = "operations-per-second"
}

variable "throughput_value" {
  description = "Value for the selected throughput measurement method"
  type        = number
  default     = 1000
}

variable "modules_enabled" {
  description = "List of Redis modules to enable (e.g., RedisJSON)"
  type        = list(string)
  default     = ["RedisJSON"]
}

variable "maintenance_start_hour" {
  description = "Hour of the day when maintenance window starts (0–23)"
  type        = number
  default     = 22
}

variable "maintenance_duration" {
  description = "Duration of the maintenance window in hours"
  type        = number
  default     = 8
}

variable "maintenance_days" {
  description = "Days of the week for the maintenance window"
  type        = list(string)
  default     = ["Tuesday", "Friday"]
}

variable "database_name" {
  description = "Name of the Redis database"
  type        = string
  default     = "redis-cloud-db"
}

variable "data_persistence" {
  description = "Persistence mode for Redis database (e.g., aof-every-1-second)"
  type        = string
  default     = "aof-every-1-second"
}

variable "tags" {
  description = "Key-value tags to associate with the database"
  type        = map(string)
  default     = {
    environment = "dev"
    owner       = "test"
  }
}

variable "modules" {
  description = "List of Redis modules to enable (e.g., RedisJSON, RedisTimeSeries)"
  type        = list(string)
  default     = ["RedisJSON"]
}