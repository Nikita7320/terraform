resource "aws_instance" "dev_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = { 
      Name = "test_instance"
    } 
}