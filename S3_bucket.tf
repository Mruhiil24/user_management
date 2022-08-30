resource "aws_s3_bucket" "mybucket" {
  bucket = "buildkite-user-audits-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
  }
}

