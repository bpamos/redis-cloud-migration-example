locals {
  redis_host = split(":", var.redis_cloud_endpoint)[0]
  redis_port = split(":", var.redis_cloud_endpoint)[1]
}


resource "null_resource" "prepare_cutover_script" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = var.ec2_application_ip
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }

    inline = [
      <<-EOF
      cat <<EOT > /home/ubuntu/do_cutover.sh
      #!/bin/bash
      echo 'REDIS_HOST=${local.redis_host}' > /opt/leaderboard_app/.env
      echo 'REDIS_PORT=${local.redis_port}' >> /opt/leaderboard_app/.env
      echo 'REDIS_PASSWORD=${var.redis_cloud_password}' >> /opt/leaderboard_app/.env
      chown ubuntu:ubuntu /opt/leaderboard_app/.env
      echo "Cutover complete: .env updated to Redis Cloud"
      EOT
      chmod +x /home/ubuntu/do_cutover.sh
      EOF
    ]
  }
}






#### OLD CUTOVER

# resource "null_resource" "redis_config_file" {
#   count = var.cutover_strategy == "config_file" ? 1 : 0

#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       host        = var.ec2_application_ip
#       user        = "ubuntu"
#       private_key = file(var.ssh_private_key_path)
#     }

#     inline = [
#       "echo '${var.redis_active_endpoint}' > /home/ubuntu/redis_target.txt"
#     ]
#   }
# }

# locals {
#   redis_endpoint_no_port = split(":", var.redis_active_endpoint)[0]
# }

# resource "aws_route53_record" "redis_cname" {
#   count   = var.cutover_strategy == "dns" ? 1 : 0

#   zone_id = var.route53_zone_id
#   name    = "redis.${var.route53_subdomain}.${var.base_domain}"
#   type    = "CNAME"
#   ttl     = 60
#   records = [local.redis_endpoint_no_port]
# }
