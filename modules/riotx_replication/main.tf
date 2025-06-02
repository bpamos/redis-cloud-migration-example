resource "null_resource" "riotx_replication" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = var.ec2_public_ip
    }

    # inline = [
    # <<-EOF
    # echo "Running RIOTX replication..."
    # echo "REDIS CLOUD URI: redis://:${var.rediscloud_password}@${var.rediscloud_private_endpoint}" >> /home/ubuntu/riotx.log
    # echo "ELASTICACHE URI: redis://${var.elasticache_endpoint}:6379" >> /home/ubuntu/riotx.log

    # riotx replicate \
    #     redis://${var.elasticache_endpoint}:6379 \
    #     redis://:${var.rediscloud_password}@${var.rediscloud_private_endpoint} \
    #     --mode LIVE \
    #     --progress log \
    #     --log-keys >> /home/ubuntu/riotx.log 2>&1
    # EOF
    # ]
    inline = [
    <<-EOF
    echo "Running RIOTX replication..." >> /home/ubuntu/riotx.log
    echo "REDIS CLOUD URI: redis://:${var.rediscloud_password}@${var.rediscloud_private_endpoint}" >> /home/ubuntu/riotx.log
    echo "ELASTICACHE URI: redis://${var.elasticache_endpoint}:6379" >> /home/ubuntu/riotx.log

    nohup riotx replicate \
      redis://${var.elasticache_endpoint}:6379 \
      redis://:${var.rediscloud_password}@${var.rediscloud_private_endpoint} \
      --mode LIVE \
      --progress log \
      --log-keys >> /home/ubuntu/riotx.log 2>&1 &
    EOF
  ]
  }
}
