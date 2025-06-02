resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name_prefix}-${var.replication_group_suffix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name    = "${var.name_prefix}-${var.replication_group_suffix}-subnet-group"
    Owner   = var.owner
    Project = var.project
  }
}

resource "aws_elasticache_parameter_group" "ksn" {
  name   = "${var.name_prefix}-${var.replication_group_suffix}-parameter-group"
  family = "redis7"

  parameter {
    name  = "notify-keyspace-events"
    value = "AKE"
  }

  parameter {
    name  = "cluster-enabled"
    value = "yes"
  }

  tags = {
    Name    = "${var.name_prefix}-${var.replication_group_suffix}-parameter-group"
    Owner   = var.owner
    Project = var.project
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.name_prefix}-${var.replication_group_suffix}"
  description                   = "Clustered ElastiCache Redis with Keyspace Notifications enabled"
  engine                        = "redis"
  engine_version                = "7.0"
  node_type                     = var.node_type
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  parameter_group_name          = aws_elasticache_parameter_group.ksn.name
  security_group_ids            = [var.security_group_id]
  num_node_groups               = var.num_shards
  replicas_per_node_group       = var.replicas_per_shard
  automatic_failover_enabled    = true
  multi_az_enabled              = true
  apply_immediately             = true
  port                          = 6379

  tags = {
    Name    = "${var.name_prefix}-${var.replication_group_suffix}"
    Owner   = var.owner
    Project = var.project
  }
}
