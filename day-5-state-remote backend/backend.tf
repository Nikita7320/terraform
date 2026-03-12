terraform {
  backend "s3" {
    bucket = "terraform-backup-7723"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}