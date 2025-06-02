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
      "echo 'waiting...'",
      "until command -v memtier_benchmark; do echo 'still waiting...'; sleep 5; done",
      "echo 'memtier installed.'"
    ]
  }
}
