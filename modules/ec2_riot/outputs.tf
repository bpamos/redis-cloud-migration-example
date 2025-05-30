output "instance_id" {
  value = aws_instance.riot.id
}

output "public_ip" {
  value = aws_instance.riot.public_ip
}

output "public_dns" {
  value = aws_instance.riot.public_dns
}

