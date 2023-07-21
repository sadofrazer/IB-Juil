data "aws_ami" "my_ami" {
  most_recent = true
  owners = ["amazon"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}



resource "aws_instance" "web" {
  ami           = data.aws_ami.my_ami.id
  instance_type = var.instance_type
  key_name = "fsa-kp-ib"
  security_groups = [ "${aws_security_group.my_sg.name}" ]
  tags = {
    Name = "${var.owner}-ec2-test"
    Formation= "terraform"
  }
}


resource "aws_eip" "my_eip" {
  instance = aws_instance.web.id
  domain   = "vpc"
}


resource "aws_security_group" "my_sg" {
  name        = "allow_http_s"
  description = "Allow HTTP/HTTPS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.owner}-sg-allow_http_s"
  }
}


output "my-eip" {
  value = aws_eip.my_eip.public_ip
}