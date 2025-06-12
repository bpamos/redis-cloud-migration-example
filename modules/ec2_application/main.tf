resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = file("${path.module}/scripts/user_data.sh")

  tags = {
    Name    = "${var.name_prefix}-app-ec2"
    Owner   = var.owner
    Project = var.project
  }
}

resource "null_resource" "app_ready" {
  depends_on = [aws_instance.app]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = aws_instance.app.public_ip
    }

    inline = [
      "echo 'waiting...',",
      "until command -v memtier_benchmark; do echo 'still waiting...'; sleep 5; done",
      "echo 'memtier installed.'"
    ]
  }
}

resource "null_resource" "install_leaderboard_app" {
  depends_on = [null_resource.app_ready]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
    host        = aws_instance.app.public_ip
  }

  # Upload files
  provisioner "file" {
    source      = "${path.module}/scripts/install_app.sh"
    destination = "/home/ubuntu/install_app.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/templates/index.html"
    destination = "/home/ubuntu/index.html"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/load_generator.py"
    destination = "/home/ubuntu/load_generator.py"
  }

  # App setup and launch
  provisioner "remote-exec" {
    inline = [
      # Export Redis ENV variables for future sessions
      "echo 'export REDIS_HOST=${var.redis_host}' >> /home/ubuntu/.bashrc",
      "echo 'export REDIS_PORT=${var.redis_port}' >> /home/ubuntu/.bashrc",
      "echo 'export REDIS_PASSWORD=${var.redis_password}' >> /home/ubuntu/.bashrc",

      # Run install script
      "chmod +x /home/ubuntu/install_app.sh",
      "sudo -u ubuntu bash /home/ubuntu/install_app.sh",

      # Ensure necessary app directories exist
      "sudo mkdir -p /opt/leaderboard_app/templates",

      # Move application files
      "sudo mv /home/ubuntu/app.py /opt/leaderboard_app/app.py",
      "sudo mv /home/ubuntu/index.html /opt/leaderboard_app/templates/index.html",
      "sudo mv /home/ubuntu/load_generator.py /opt/leaderboard_app/load_generator.py",

      # Kill any running app on port 5000
      "sudo lsof -ti:5000 | xargs --no-run-if-empty sudo kill -9 || true",

      # Launch Flask app
      "nohup /opt/leaderboard_app/venv/bin/python /opt/leaderboard_app/app.py > /opt/leaderboard_app/app.log 2>&1 &",

      # Verify app is running
      "for i in {1..10}; do curl --fail --silent http://localhost:5000/healthz && break || echo 'Waiting for app...' && sleep 1; done",
      "pgrep -f app.py || { echo 'App process not found'; exit 1; }",
      "sudo lsof -i :5000 || { echo 'App not listening on port 5000'; exit 1; }"
    ]
  }
}

resource "null_resource" "create_redis_config" {
  depends_on = [null_resource.install_leaderboard_app]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
      host        = aws_instance.app.public_ip
    }

    inline = [
      # Ensure the directory exists
      "sudo mkdir -p /opt/leaderboard_app",
      "sudo chown ubuntu:ubuntu /opt/leaderboard_app",

      # Write the .env file
      "echo 'REDIS_HOST=${var.redis_host}' > /opt/leaderboard_app/.env",
      "echo 'REDIS_PORT=${var.redis_port}' >> /opt/leaderboard_app/.env",
      "echo 'REDIS_PASSWORD=${var.redis_password}' >> /opt/leaderboard_app/.env",
      "sudo chown ubuntu:ubuntu /opt/leaderboard_app/.env"
    ]
  }
}
