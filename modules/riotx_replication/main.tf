resource "null_resource" "create_riotx_script" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = var.ec2_public_ip
    }

    inline = [
      <<-EOT
        cat <<EOF > /home/ubuntu/start_riotx.sh
    #!/bin/bash
    echo "Running RIOTX replication..." >> /home/ubuntu/riotx.log
    echo "REDIS CLOUD URI: redis://:${var.rediscloud_password}@${var.rediscloud_private_endpoint}" >> /home/ubuntu/riotx.log
    echo "ELASTICACHE URI: redis://${var.elasticache_endpoint}:6379" >> /home/ubuntu/riotx.log
    riotx replicate \\
      redis://${var.elasticache_endpoint}:6379 \\
      redis://:${var.rediscloud_password}@${var.rediscloud_private_endpoint} \\
      --mode LIVE \\
      --progress log \\
      --log-keys \\
      --metrics \\
      --metrics-jvm \\
      --metrics-redis \\
      --metrics-name=riotx \\
      --metrics-port=8080 >> /home/ubuntu/riotx.log 2>&1
    EOF

    chmod +x /home/ubuntu/start_riotx.sh
      EOT
    ]

  }
}

resource "null_resource" "run_riotx_script" {
  depends_on = [null_resource.create_riotx_script]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = var.ec2_public_ip
    }

    inline = [
      "sudo apt-get update -y && sudo apt-get install -y at",
      "echo \"/home/ubuntu/start_riotx.sh\" | at now"
    ]
  }
}

#### WORKS

# resource "null_resource" "create_riotx_script" {
#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file(var.ssh_private_key_path)
#       host        = var.ec2_public_ip
#     }

#     inline = [
#       <<-EOT
#         cat <<EOF > /home/ubuntu/start_riotx.sh
# #!/bin/bash
# echo "Running RIOTX replication..." >> /home/ubuntu/riotx.log
# echo "REDIS CLOUD URI: redis://:${var.rediscloud_password}@${var.rediscloud_private_endpoint}" >> /home/ubuntu/riotx.log
# echo "ELASTICACHE URI: redis://${var.elasticache_endpoint}:6379" >> /home/ubuntu/riotx.log
# riotx replicate \\
#   redis://${var.elasticache_endpoint}:6379 \\
#   redis://:${var.rediscloud_password}@${var.rediscloud_private_endpoint} \\
#   --mode LIVE \\
#   --progress log \\
#   --log-keys >> /home/ubuntu/riotx.log 2>&1
# EOF

# chmod +x /home/ubuntu/start_riotx.sh
#       EOT
#     ]
#   }
# }

# resource "null_resource" "run_riotx_script" {
#   depends_on = [null_resource.create_riotx_script]

#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file(var.ssh_private_key_path)
#       host        = var.ec2_public_ip
#     }

#     inline = [
#       "sudo apt-get update -y && sudo apt-get install -y at",
#       "echo \"/home/ubuntu/start_riotx.sh\" | at now"
#     ]
#   }
# }