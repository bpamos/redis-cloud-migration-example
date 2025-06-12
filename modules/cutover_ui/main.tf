resource "null_resource" "deploy_cutover_ui" {
  depends_on = []

  # Upload UI server script
  provisioner "file" {
    source      = "${path.module}/scripts/ui_server.py"
    destination = "/home/ubuntu/ui_server.py"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = var.ec2_application_ip
    }
  }

  # Upload install script
  provisioner "file" {
    source      = "${path.module}/scripts/install_ui.sh"
    destination = "/home/ubuntu/install_ui.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = var.ec2_application_ip
    }
  }

  # Remote execution with debug output
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = var.ec2_application_ip
    }

    inline = [
      "set -x",  # Echo each command
      "set -e",  # Exit immediately on any error (Terraform does this by default, but explicit is better)

      "echo 'Saving vars to /home/ubuntu/.cutover_env'",
      "echo 'REDIS_CLOUD_ENDPOINT=${var.redis_cloud_endpoint}' > /home/ubuntu/.cutover_env",
      "echo 'REDIS_CLOUD_PORT=${var.redis_cloud_port}' >> /home/ubuntu/.cutover_env",
      "echo 'REDIS_CLOUD_PASSWORD=${var.redis_cloud_password}' >> /home/ubuntu/.cutover_env",
      "echo 'EC2_PUBLIC_IP=${var.ec2_application_ip}' >> /home/ubuntu/.cutover_env",

      "echo 'Showing contents of /home/ubuntu/.cutover_env'",
      "cat /home/ubuntu/.cutover_env || echo 'Could not read .cutover_env'",

      "echo 'Making install_ui.sh executable'",
      "chmod +x /home/ubuntu/install_ui.sh || echo 'chmod failed'",

      "echo 'Running install_ui.sh...'",
      "/home/ubuntu/install_ui.sh || echo 'install_ui.sh failed'"
    ]


  }

}
