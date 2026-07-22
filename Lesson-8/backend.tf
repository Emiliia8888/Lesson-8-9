terraform {
  backend "s3" {
    bucket         = "emiliia-ft-state-lesson-99"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
