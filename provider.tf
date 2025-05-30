terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    rediscloud = {
      source  = "RedisLabs/rediscloud"
      version = "2.1.4"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

provider "rediscloud" {
  api_key    = var.rediscloud_api_key
  secret_key = var.rediscloud_secret_key
}
