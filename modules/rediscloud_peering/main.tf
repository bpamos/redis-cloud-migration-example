resource "null_resource" "wait_for_subscription_activation" {
  provisioner "local-exec" {
    command = "echo 'Waiting for Redis Cloud subscription activation...' && sleep 60"
  }

  triggers = {
    subscription_id = var.subscription_id
  }
}

resource "rediscloud_subscription_peering" "peering" {
  subscription_id = var.subscription_id
  region          = var.region
  aws_account_id  = var.aws_account_id
  vpc_id          = var.vpc_id
  vpc_cidr        = var.vpc_cidr

  timeouts {
    create = "10m"
    delete = "10m"
  }

  depends_on = [
    null_resource.wait_for_subscription_activation
  ]
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  vpc_peering_connection_id = rediscloud_subscription_peering.peering.aws_peering_id
  auto_accept               = true
}

resource "aws_route" "rediscloud_route" {
  route_table_id            = var.route_table_id
  destination_cidr_block    = var.peer_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter.id
}

