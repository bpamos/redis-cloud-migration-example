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

