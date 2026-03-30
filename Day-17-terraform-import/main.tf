resource "aws_instance" "name" {
    ami = "ami-0c3389a4fa5bddaad"
    instance_type = "t3.micro"
    subnet_id = "subnet-0bdaa90526ad46e61"
     vpc_security_group_ids = ["sg-0636e02fadaa9a6c9"]
    tags = {
        Name = "test"
 
}
    }   

  
