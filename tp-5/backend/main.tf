resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "${var.author}-terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.author}-terraform-state-lock-dynamo"
  }
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.author}-tfsate-bucket"
  tags = {
    Name = "${var.author}-tfsate-bucket"
  }
}


variable "author" {
  default = "fsa"
}