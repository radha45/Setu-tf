resource "random_password" "master"{
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  name = "Setu-db-password"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

resource "aws_security_group" "private-rds-instance" {
  name                                      = "${var.project}-rds-instance"
  description                               = "${var.project} rds instance security group"
  vpc_id                                    = aws_vpc.vpc.id

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = ["${aws_security_group.private-instance.id}"]
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "rds-subnet-group"

  subnet_ids = data.aws_subnet_ids.private-subnets.ids

  tags = {
    Name      = "${var.project}-rds-subnet-group"
    project   = var.project
    managedBy = "terraform"
  }
}


resource "aws_db_instance" "Setu" {
  identifier            = var.identifier
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name

  username             = var.username
  password             = random_password.master.result
  multi_az               = true
  vpc_security_group_ids = [aws_security_group.private-rds-instance.id]
  db_subnet_group_name = aws_db_subnet_group.private.name
  skip_final_snapshot = true
#   apply_immediately = true
  port     = 3306
  tags = {
    Name      = "${var.project}-rds"
    project   = var.project
    managedBy = "terraform"
  }
}