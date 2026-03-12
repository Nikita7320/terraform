resource "aws_instance" "uat" {
    ami = var.uat_ami_id
    instance_type = var.dev_instance_type
    provider = aws.devenv
    tags = {
        Name = "uat-instance"
    }
}
resource "aws_instance" "test" {
    ami = var.test_ami_id
    instance_type = var.test_instance_type
    provider = aws.testenv
    tags = {
        Name = "test-instance"
    }
}