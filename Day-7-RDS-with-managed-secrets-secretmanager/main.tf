resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "subnet-2"
  }
}
# this is subnet group that created for RDS instance
resource "aws_db_subnet_group" "my_sg" {
  name = "rds-db-subnet-group"

  subnet_ids = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id
  ]

  tags = {
    Name = "my-db-subnet-group"
  }
}
  # thi is RDS instance that created all configuration in this instance
resource "aws_db_instance" "main" {
  identifier         = "rdsdbinstance"
  allocated_storage  = 20
  engine             = "mysql"
  engine_version     = "8.4"
  instance_class     = "db.t3.micro"

  db_name  = "mydatabase"
  username = "admin"
  password = "admin12345"
#here you can use secreat manager
# manage_master_user_password = true #rds and secret manager manage this password
  db_subnet_group_name = aws_db_subnet_group.my_sg.name
  parameter_group_name = "default.mysql8.4"

  backup_retention_period = 1
  backup_window      = "18:00-19:00"
maintenance_window = "Sun:19:00-Sun:20:00"

  deletion_protection = false
  skip_final_snapshot = true

  depends_on = [aws_db_subnet_group.my_sg]
vpc_security_group_ids = [aws_security_group.rds_sg.id]


}
#  this is replica that created
resource "aws_db_instance" "replica" {
  identifier             = "rdsdb-replica"
   replicate_source_db = aws_db_instance.main.arn
  instance_class         = "db.t3.micro"
db_subnet_group_name = aws_db_subnet_group.my_sg.name
  publicly_accessible    = false
  auto_minor_version_upgrade = true

  depends_on = [aws_db_instance.main]
}
# iam ploicy for monitoring RDS instance
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
} 
# this is security group for RDS instance

resource "aws_security_group" "rds_sg" {
  name   = "rds-security-group"
  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}