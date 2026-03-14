terraform {
  backend "s3" {
    bucket = "terraform-s3-lockfile-123"
    key    = "day-6/terraform.tfstate"
    region = "us-east-1"
    # Enable S3 native locking
    #use_lockfile = true   #tf version should be above 1.10
    # The dynamodb_table argument is no longer needed
    dynamodb_table = "statelock-dyanamoDB"

  }
}