resource "aws_instance" "name" {
    ami = "ami-0f559c3642608c138"
    tnstance_type ="t2 microw"

tag =
Name =dev-instance
}