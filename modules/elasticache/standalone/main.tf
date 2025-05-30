resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name_prefix}-standalone-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name    = "${var.name_prefix}-standalone-subnet-group"
    Owner   = var.owner
    Project = var.project
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.name_prefix}-standalone"
  description                   = "Standalone (non-clustered) ElastiCache Redis with optional replicas"
  engine                        = "redis"
  engine_version                = "7.0"
  node_type                     = var.node_type
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  security_group_ids            = [var.security_group_id]
  replicas_per_node_group       = var.replicas
  automatic_failover_enabled    = var.replicas > 0 ? true : false
  multi_az_enabled              = var.replicas > 0 ? true : false
  apply_immediately             = true
  port                          = 6379

  tags = {
    Name    = "${var.name_prefix}-standalone"
    Owner   = var.owner
    Project = var.project
  }
}
