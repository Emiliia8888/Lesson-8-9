terraform {
  backend "s3" {
    bucket         = "emiliia-ft-state-lesson-99"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"            # Для блокування стану
    encrypt        = true
  }
}