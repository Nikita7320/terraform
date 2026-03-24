resource "aws_instance" "demo" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t2.micro"

  lifecycle {
   create_before_destroy = true
  }

  tags = {
    Name = "lifecycle-test"
  }
}