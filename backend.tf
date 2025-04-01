terraform {
  backend "s3" {
    bucket         = "taylie-vpc-project-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true
  }
}
