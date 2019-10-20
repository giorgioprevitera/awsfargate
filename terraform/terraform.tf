provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "fargatetest-terraform"
    key    = "tfstate"
    region = "eu-west-1"
  }
}
