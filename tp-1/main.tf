resource "aws_instance" "web" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name = "fsa-kp-ib"
  tags = {
    Name = "fsa-ec2-test"
    Formation= "terraform"
  }
}