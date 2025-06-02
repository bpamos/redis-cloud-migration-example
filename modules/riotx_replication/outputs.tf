output "riotx_replication_triggered" {
  description = "Indicates that RIOTX live replication was triggered via remote-exec."
  value       = true
}

output "replicating_from" {
  description = "Source Redis (ElastiCache) endpoint used in the replication."
  value       = var.elasticache_endpoint
}

output "replicating_to" {
  description = "Target Redis Cloud endpoint used in the replication."
  value       = var.rediscloud_private_endpoint
}
