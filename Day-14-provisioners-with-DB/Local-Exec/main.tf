provider "aws" {
  region = "us-east-1"
}


# Create the RDS instance

resource "aws_security_group" "rds_sg" {
  name = "rds-sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # testing only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "mysql_rds" {
  identifier              = "my-mysql-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "Password123!"
  db_name                 = "dev"
  allocated_storage       = 20
  skip_final_snapshot     = true
  publicly_accessible     = true

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
}
# Use null_resource to execute the SQL script from your local machine
resource "null_resource" "local_sql_exec" {

  provisioner "local-exec" {
    command = "mysql -h my-mysql-db.cspyogikkr6m.us-east-1.rds.amazonaws.com -u admin -pPassword123! < init.sql"

    interpreter = ["C:\\Program Files\\Git\\bin\\bash.exe", "-c"]
  }

  triggers = {
    always_run = timestamp()
  }
}