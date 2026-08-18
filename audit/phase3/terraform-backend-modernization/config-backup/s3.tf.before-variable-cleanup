resource "aws_s3_bucket" "terraform_state" {
  bucket = "emiliia-ft-state-lesson-99"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}