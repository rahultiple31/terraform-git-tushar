terraform {
  backend "s3" {
    bucket = "terraformtushar123.com"
    key    = "app/flipkart/dev/terraform.tfstate"
    region = "ap-south-1"
    #use_lockfile = "true"
  }
}
