provider "aws" {
  region = "us-east-1"
}
resource "aws_security_group" "ec2_sg" {
  name = "ec2-sg"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ testing only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# EC2 instance
resource "aws_instance" "sql_runner" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  key_name                    = "my-key"
  associate_public_ip_address = true
 
  tags = {
    Name = "SQL Runner"
  }
}

# RDS instance (FIXED NAME ✅)
resource "aws_db_instance" "mysql_rds" {
  identifier          = "my-mysql-db-1"   # name change to avoid duplicate error
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "Password123!"
  allocated_storage   = 20
  skip_final_snapshot = true
  publicly_accessible = true
}

# Run SQL remotely
resource "null_resource" "remote_sql_exec" {

  depends_on = [
    aws_db_instance.mysql_rds,
    aws_instance.sql_runner
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/dell/Downloads/my-key.pem")
    host        = aws_instance.sql_runner.public_ip
  }

  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y mysql",
      "mysql -h ${aws_db_instance.mysql_rds.address} -u admin -pPassword123! < /tmp/init.sql"
    ]
  }

  triggers = {
    always_run = timestamp()
  }
}