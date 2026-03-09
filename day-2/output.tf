output "public_ip" {
  value = aws_instance.dev_instance.public_ip
}
output "private_ip" {
    value = aws_instance.dev_instance.private_ip
}
output "az" {
    value = aws_instance.dev_instance.availability_zone
}