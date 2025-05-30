# modules/rediscloud_peering/variables.tf

variable "subscription_id" {
  description = "ID of the Redis Cloud subscription"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID of the VPC to be peered"
  type        = string
}

variable "region" {
  description = "AWS region of the VPC"
  type        = string
}

variable "vpc_id" {
  description = "ID of the AWS VPC to be peered"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR of the AWS VPC to be peered"
  type        = string
}

variable "route_table_id" {
  description = "ID of the AWS route table to update"
  type        = string
}

variable "peer_cidr_block" {
  description = "CIDR block of the Redis Cloud network to route to"
  type        = string
}
