terraform {
  backend "s3" {
    bucket = "terraformstatelocalremote"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}