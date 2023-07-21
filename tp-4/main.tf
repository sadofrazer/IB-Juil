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

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get -y install nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/sadofrazer/Données/DevOps/AWS/.aws/fsa-kp-ib.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "${var.owner}-${var.env}-ec2-test"
    Formation= "terraform"
  }
}


resource "aws_eip" "my_eip" {
  instance = aws_instance.web.id
  domain   = "vpc"
  provisioner "local-exec" {
    command = " echo 'public_ip : ${self.public_ip} | ec2_id: ${aws_instance.web.id} | ec2_AZ: ${aws_instance.web.availability_zone}' > ./ec2_infos.txt"
  }
}


resource "aws_security_group" "my_sg" {
  name        = "allow_http_s-${var.env}"
  description = "Allow HTTP/HTTPS inbound traffic"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = "${var.owner}-sg-allow_http_s--${var.env}"
  }
}


output "my-eip" {
  value = aws_eip.my_eip.public_ip
}