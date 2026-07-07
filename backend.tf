terraform {
  backend "s3" {
    bucket = "emiliia-tf-state-lesson-99"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}