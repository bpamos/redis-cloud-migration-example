resource "aws_security_group" "riot_ec2" {
  name        = "${var.name_prefix}-riot-ec2-sg"
  description = "Security group for EC2 RIOT/Redis OSS"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow SSH (optional)"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.allow_ssh_from
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.name_prefix}-riot-ec2-sg"
    Owner   = var.owner
    Project = var.project
  }
}

resource "aws_security_group" "elasticache" {
  name        = "${var.name_prefix}-elasticache-sg"
  description = "Security group for ElastiCache"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Redis access from EC2"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.riot_ec2.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.name_prefix}-elasticache-sg"
    Owner   = var.owner
    Project = var.project
  }
}
