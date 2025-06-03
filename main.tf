


module "vpc" {
  source              = "./modules/vpc"
  name_prefix         = var.name_prefix
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                 = var.azs
  owner               = var.owner
  project             = var.project
}

module "security_group" {
  source     = "./modules/security_group"
  name_prefix = var.name_prefix
  vpc_id      = module.vpc.vpc_id
  owner       = var.owner
  project     = var.project
  allow_ssh_from = ["0.0.0.0/0"] # Replace with your ["YOUR_IP/32"] or leave default
}

#### Elasticache Standalone

# module "elasticache_standalone" {
#   source                   = "./modules/elasticache/standalone"
#   name_prefix              = var.name_prefix
#   replication_group_suffix = "standalone"
#   subnet_ids               = module.vpc.private_subnet_ids
#   security_group_id        = module.security_group.elasticache_sg_id
#   node_type                = var.node_type
#   replicas                 = var.standalone_replicas
#   owner                    = var.owner
#   project                  = var.project
# }

#### Elasticache Clustered

# module "elasticache_clustered" {
#   source                   = "./modules/elasticache/clustered"
#   name_prefix              = var.name_prefix
#   replication_group_suffix = "clustered"
#   subnet_ids               = module.vpc.private_subnet_ids
#   security_group_id        = module.security_group.elasticache_sg_id
#   node_type                = var.node_type
#   num_shards               = var.num_shards
#   replicas_per_shard       = var.replicas_per_shard
#   owner                    = var.owner
#   project                  = var.project
# }

#### Elasticache with KSN enabled

module "elasticache_standalone_ksn" {
  source                   = "./modules/elasticache/standalone_ksn_enabled"
  name_prefix              = var.name_prefix
  replication_group_suffix = "standalone-ksn"
  subnet_ids               = module.vpc.private_subnet_ids
  security_group_id        = module.security_group.elasticache_sg_id
  node_type                = var.node_type
  replicas                 = var.standalone_replicas
  owner                    = var.owner
  project                  = var.project
}


# module "elasticache_clustered_ksn" {
#   source                   = "./modules/elasticache/clustered_ksn_enabled"
#   name_prefix              = var.name_prefix
#   replication_group_suffix = "clustered-ksn"
#   subnet_ids               = module.vpc.private_subnet_ids
#   security_group_id        = module.security_group.elasticache_sg_id
#   node_type                = var.node_type
#   num_shards               = var.num_shards
#   replicas_per_shard       = var.replicas_per_shard
#   owner                    = var.owner
#   project                  = var.project
# }

#### RIOT EC2

module "ec2_riot" {
  source               = "./modules/ec2_riot"
  name_prefix          = var.name_prefix
  owner                = var.owner
  project              = var.project
  ami_id               = var.ami_id
  instance_type        = var.ec2_instance_type
  subnet_id            = module.vpc.public_subnet_ids[0] # Public subnet for access
  security_group_id    = module.security_group.riot_ec2_sg_id
  key_name             = var.key_name
  ssh_private_key_path = var.ssh_private_key_path
}

#### EC2 Application

module "ec2_application" {
  source               = "./modules/ec2_application"
  name_prefix          = var.name_prefix
  owner                = var.owner
  project              = var.project
  ami_id               = var.ami_id
  instance_type        = var.ec2_instance_type
  subnet_id            = module.vpc.public_subnet_ids[1]
  security_group_id    = module.security_group.riot_ec2_sg_id
  key_name             = var.key_name
  ssh_private_key_path = var.ssh_private_key_path
}


#### Redis Cloud

module "rediscloud" {
  source = "./modules/rediscloud"

  rediscloud_api_key        = var.rediscloud_api_key
  rediscloud_secret_key     = var.rediscloud_secret_key
  subscription_name         = var.subscription_name
  rediscloud_region         = var.rediscloud_region
  cloud_provider            = var.cloud_provider
  networking_deployment_cidr = var.networking_deployment_cidr
  preferred_azs             = var.preferred_azs
  credit_card_type          = var.credit_card_type
  credit_card_last_four     = var.credit_card_last_four
  redis_version             = var.redis_version
  memory_storage            = var.memory_storage
  dataset_size_in_gb        = var.dataset_size_in_gb
  throughput_value          = var.throughput_value
  modules_enabled           = var.modules_enabled
}


module "rediscloud_peering" {
  source                  = "./modules/rediscloud_peering"
  subscription_id         = module.rediscloud.rediscloud_subscription_id
  aws_account_id          = var.aws_account_id
  region                  = var.rediscloud_region
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = var.vpc_cidr
  route_table_id          = module.vpc.route_table_id
  peer_cidr_block         = var.peer_cidr_block

  depends_on = [
    module.rediscloud
  ]
}

#### RIOTX Replication

module "riotx_replication" {
  source = "./modules/riotx_replication"

  ec2_public_ip               = module.ec2_riot.public_ip
  ssh_private_key_path        = var.ssh_private_key_path

  # Use the KSN-enabled modules for live replication
  elasticache_endpoint        = module.elasticache_standalone_ksn.primary_endpoint

  rediscloud_private_endpoint = module.rediscloud.database_private_endpoint
  rediscloud_password         = module.rediscloud.rediscloud_password

  depends_on = [
    module.elasticache_standalone_ksn, # change to ksn enabled modules for live replication
    module.rediscloud,
    module.rediscloud_peering,
    module.ec2_riot,
    module.ec2_riot.riotx_ready_id
  ]
}


#### create memtier

module "create_memtier" {
  source               = "./modules/scripts/create_memtier"
  host                 = module.ec2_application.public_ip
  ssh_private_key_path = var.ssh_private_key_path
  redis_endpoint       = module.elasticache_standalone_ksn.primary_endpoint

  depends_on = [
    module.elasticache_standalone_ksn,
    module.ec2_application
  ]
}


