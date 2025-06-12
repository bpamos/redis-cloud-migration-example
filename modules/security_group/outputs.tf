output "riot_ec2_sg_id" {
  value = aws_security_group.riot_ec2.id
}

output "elasticache_sg_id" {
  value = aws_security_group.elasticache.id
}

### Leaderboard App

output "ec2_application_sg_id" {
  description = "ID of the security group used for the application EC2 instance"
  value       = aws_security_group.ec2_application.id
}