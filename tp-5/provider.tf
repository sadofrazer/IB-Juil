provider "aws" {
  region                  = "us-east-1"
  shared_credentials_files = ["/Users/sadofrazer/Données/DevOps/AWS/.aws/credentials"]
}


terraform {
  backend "s3" {
    bucket                  = "fsa-tfsate-bucket"
    key                     = "frazer.tfstate"
    region                  = "us-east-1"
    shared_credentials_file = "/Users/sadofrazer/Données/DevOps/AWS/.aws/credentials"
    dynamodb_table = "fsa-terraform-state-lock-dynamo"
  }
}