resource "aws_security_group" "riot_ec2" {
  name        = "${var.name_prefix}-riot-ec2-sg"
  description = "Security group for EC2 RIOT/Redis OSS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
  }

  ingress {
    description = "Grafana UI"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
  }

  ingress {
    description = "Prometheus UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
  }

  ingress {
    description = "RIOTX Prometheus Metrics Exporter"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
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
    description     = "Allow Redis access from RIOT EC2"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.riot_ec2.id]
  }

  ingress {
    description     = "Allow Redis access from Flask app EC2"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_application.id]
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


#### Leaderboard App

resource "aws_security_group" "ec2_application" {
  name        = "${var.name_prefix}-ec2-app-sg"
  description = "Security group for Flask leaderboard EC2 app"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
  }

  ingress {
    description = "Allow HTTP access to Flask app"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
  }

    ingress {
    description = "Allow HTTP access to Cutover UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
  }

  egress {
    description = "Allow all outbound (needed to reach Redis)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.name_prefix}-ec2-app-sg"
    Owner   = var.owner
    Project = var.project
  }
}
