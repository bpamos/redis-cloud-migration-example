output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "route_table_id" {
  value = module.vpc.route_table_id
}

### Elasticache

# output "elasticache_standalone_endpoint" {
#   description = "Primary endpoint of the standalone (non-clustered) Redis"
#   value       = module.elasticache_standalone.primary_endpoint
# }

# output "elasticache_clustered_endpoint" {
#   description = "Primary endpoint of the clustered Redis group"
#   value       = module.elasticache_clustered.primary_endpoint_address
# }

# output "elasticache_clustered_id" {
#   description = "Replication group ID of clustered Redis"
#   value       = module.elasticache_clustered.replication_group_id
# }

# output "elasticache_standalone_id" {
#   description = "Replication group ID of standalone Redis"
#   value       = module.elasticache_standalone.replication_group_id
# }

### Elasticache Standalonewith KSN enabled

output "elasticache_standalone_ksn_primary_endpoint" {
  value = module.elasticache_standalone_ksn.primary_endpoint
}

output "elasticache_standalone_ksn_replication_group_id" {
  value = module.elasticache_standalone_ksn.replication_group_id
}

output "elasticache_standalone_ksn_parameter_group" {
  value = module.elasticache_standalone_ksn.parameter_group_name
}

### Elasticache Clustered with KSN enabled

# output "elasticache_clustered_ksn_primary_endpoint" {
#   value = module.elasticache_clustered_ksn.primary_endpoint_address
# }

# output "elasticache_clustered_ksn_replication_group_id" {
#   value = module.elasticache_clustered_ksn.replication_group_id
# }

# output "elasticache_clustered_ksn_parameter_group" {
#   value = module.elasticache_clustered_ksn.parameter_group_name
# }


# RIOT EC2

output "ec2_riot_instance_id" {
  value = module.ec2_riot.instance_id
}

output "ec2_riot_public_ip" {
  value = module.ec2_riot.public_ip
}

output "ec2_riot_public_dns" {
  value = module.ec2_riot.public_dns
}

output "ec2_riot_riotx_ready_id" {
  description = "Indicates when the riotx binary is ready on the EC2 instance"
  value       = module.ec2_riot.riotx_ready_id
}

### EC2 Application

output "application_ec2_public_ip" {
  value = module.ec2_application.public_ip
}

output "application_ec2_private_ip" {
  value = module.ec2_application.private_ip
}

output "application_ec2_instance_id" {
  value = module.ec2_application.instance_id
}


### Redis Cloud

output "rediscloud_subscription_id" {
  value       = module.rediscloud.rediscloud_subscription_id
  description = "Redis Cloud subscription ID"
}

output "rediscloud_database_id" {
  value       = module.rediscloud.database_id
  description = "Redis Cloud database ID"
}

output "rediscloud_public_endpoint" {
  value       = module.rediscloud.database_public_endpoint
  description = "Public endpoint for Redis Cloud database"
}

output "rediscloud_private_endpoint" {
  value       = module.rediscloud.database_private_endpoint
  description = "Private endpoint for Redis Cloud database"
}

output "rediscloud_password" {
  value       = module.rediscloud.rediscloud_password
  description = "Password to access Redis Cloud database"
  sensitive   = true
}

### RIOTX replication

output "riotx_replication_status" {
  description = "Outputs status and endpoints used by the riotx_replication module."
  value = {
    triggered = module.riotx_replication.riotx_replication_triggered
    source    = module.riotx_replication.replicating_from
    target    = module.riotx_replication.replicating_to
  }
}

