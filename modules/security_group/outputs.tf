output "riot_ec2_sg_id" {
  value = aws_security_group.riot_ec2.id
}

output "elasticache_sg_id" {
  value = aws_security_group.elasticache.id
}
