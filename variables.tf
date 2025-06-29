variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "redis-demo"
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
}

variable "project" {
  description = "Project or environment name"
  type        = string
}

### security group
variable "allow_ssh_from" {
  description = "List of CIDRs allowed to SSH into EC2"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Elasticache
variable "node_type" {
  description = "ElastiCache instance type for both standalone and clustered"
  type        = string
  default     = "cache.t3.micro"
}

variable "standalone_replicas" {
  description = "Number of replicas for the standalone Redis"
  type        = number
  default     = 0
}

variable "num_shards" {
  description = "Number of Redis shards for clustered ElastiCache"
  type        = number
  default     = 2
}

variable "replicas_per_shard" {
  description = "Number of replicas per shard"
  type        = number
  default     = 1
}

# RIOT EC2
variable "ami_id" {
  description = "AMI ID to launch EC2"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the private key file for SSH"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type for RIOT + Redis OSS"
  type        = string
  default     = "t2.xlarge"
}

### Redis Cloud
variable "rediscloud_api_key" {
  description = "Redis Cloud API key"
  type        = string
}

variable "rediscloud_secret_key" {
  description = "Redis Cloud API secret"
  type        = string
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
  description = "Cloud provider region for Redis Cloud deployment"
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

variable "peer_cidr_block" {
  description = "The Redis Cloud networking CIDR block to route into AWS VPC"
  type        = string
  default     = "10.42.0.0/24"
}

variable "aws_account_id" {
  description = "AWS Account ID for Redis Cloud VPC peering"
  type        = string
}

### elasticache vars for leaderboard app

# variable "redis_host" {
#   description = "The hostname of the Redis server (ElastiCache or Redis Cloud)"
#   type        = string
# }

variable "redis_port" {
  description = "The Redis server port"
  type        = number
  default     = 6379
}

variable "redis_password" {
  description = "Redis password (optional, used for Redis Cloud)"
  type        = string
  default     = ""
}

output "ec2_application_sg_id" {
  value = module.security_group.ec2_application_sg_id
}

##### Cutover
# variable "redis_active_endpoint" {
#   description = "Redis Cloud endpoint to use for cutover (host:port)"
#   type        = string
# }

# variable "ssh_private_key_path" {
#   description = "Path to SSH private key for connecting to app EC2"
#   type        = string
# }

# variable "ec2_application_ip" {
#   description = "Public IP address of the EC2 application node"
#   type        = string
# }


##### OLD CUTOVER

# # Cutover Strategy and Redis Target

# variable "cutover_strategy" {
#   description = "Which cutover strategy to use: dns or config_file"
#   type        = string
#   default     = "dns"
# }

# # Only needed for DNS strategy
# variable "route53_zone_id" {
#   description = "Route 53 hosted zone ID for redis DNS cutover"
#   type        = string
#   default     = ""
# }

# variable "route53_subdomain" {
#   description = "Subdomain to create for redis DNS (e.g., 'demo' → redis.demo.example.com)"
#   type        = string
#   default     = ""
# }

# variable "base_domain" {
#   description = "Base domain name used for DNS (e.g., 'example.com')"
#   type        = string
#   default     = "redisdemo.com"
# }

# variable "initial_redis_endpoint" {
#   description = "The initial Redis endpoint to point DNS to before cutover"
#   type        = string
#   default     = ""  # we’ll assign dynamically
# }

# variable "enable_initial_dns" {
#   description = "Whether to create the initial DNS record to point to ElastiCache"
#   type        = bool
#   default     = true
# }