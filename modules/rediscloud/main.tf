data "rediscloud_payment_method" "card" {
  card_type         = var.credit_card_type
  last_four_numbers = var.credit_card_last_four
}

resource "rediscloud_subscription" "redis" {
  name              = var.subscription_name
  payment_method    = "credit-card"
  payment_method_id = data.rediscloud_payment_method.card.id
  memory_storage    = var.memory_storage
  redis_version     = var.redis_version

  cloud_provider {
    provider = var.cloud_provider

    region {
      region                        = var.rediscloud_region
      multiple_availability_zones  = var.multi_az
      networking_deployment_cidr   = var.networking_deployment_cidr
      preferred_availability_zones = var.preferred_azs
    }
  }

  creation_plan {
    dataset_size_in_gb           = var.dataset_size_in_gb
    quantity                     = var.database_quantity
    replication                  = var.replication
    throughput_measurement_by    = var.throughput_by
    throughput_measurement_value = var.throughput_value
    modules                      = var.modules
  }

  maintenance_windows {
    mode = "manual"
    window {
      start_hour        = var.maintenance_start_hour
      duration_in_hours = var.maintenance_duration
      days              = var.maintenance_days
    }
  }
}

resource "rediscloud_subscription_database" "db" {
  subscription_id               = rediscloud_subscription.redis.id
  name                          = var.database_name
  dataset_size_in_gb           = var.dataset_size_in_gb
  data_persistence             = var.data_persistence
  throughput_measurement_by    = var.throughput_by
  throughput_measurement_value = var.throughput_value
  replication                  = var.replication

  modules = [for mod in var.modules : { name = mod }]

  alert {
    name  = "dataset-size"
    value = 95
  }

  tags = var.tags
}
