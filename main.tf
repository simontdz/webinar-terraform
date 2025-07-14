############ provider ########
provider "aws" {
  region = "us-east-1"
}

############ resource ########
resource "aws_instance" "nginx-server" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t3.micro"

  user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y nginx
                sudo systemctl enable nginx
                sudo systemctl start nginx
                EOF

  key_name = aws_key_pair.nginx-server-ssh.key_name

  vpc_security_group_ids = [
    aws_security_group.ngnix-server-sg.id
  ]

  tags = {
    Name        = "ngnix-server"
    Environment = "test"
    Owner       = "simontdz123@gmail.com"
    Team        = "Devops"
    Project     = "Webinar"
  }

}

######SSH#######
# ssh-keygen -t rsa -b 2048 -f "ngnix-server.key"

resource "aws_key_pair" "nginx-server-ssh" {
  key_name   = "ngnix-server-ssh"
  public_key = file("ngnix-server.key.pub")

    tags = {
    Name        = "ngnix-server-ssh"
    Environment = "test"
    Owner       = "simontdz123@gmail.com"
    Team        = "Devops"
    Project     = "Webinar"
  }

}

######SG#######
resource "aws_security_group" "ngnix-server-sg" {
  name        = "ngnix-server-sg"
  description = "Security group allowing SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name        = "ngnix-server-sg"
    Environment = "test"
    Owner       = "simontdz123@gmail.com"
    Team        = "Devops"
    Project     = "Webinar"
  }
}

####### output #######
output "server_public_ip" {
  description = "Direccion IP pública de la instancia EC2"
  value = aws_instance.nginx-server.public_ip
}

output "server_public_dns" {
  description = "DNS público de la instancia EC2"
  value = aws_instance.nginx-server.public_dns
}
