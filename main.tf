terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = var.region
  profile = var.aws_profile
}
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_instance" "public_instance" {
  ami                    = "ami-0014ce3e52359afbd"
  instance_type          = "t3.micro"
  key_name               = "admin_key"

 vpc_security_group_ids = [aws_security_group.sg_ec2.id] 

 root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  tags = {
    Name = var.instance_name
  }
    provisioner "remote-exec" {
    inline = [
        "sudo apt-get update -y",
        "sudo apt-get install -y ca-certificates curl gnupg",
        "sudo install -m 0755 -d /etc/apt/keyrings",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
        "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
        "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
        "sudo apt-get update -y",
        "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
         "sudo systemctl start docker"
   ]
 }



      connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("admin_key.pem")
    host        = aws_instance.public_instance.public_ip
  }
  

}





resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"

  # Ingress rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules (allow all traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



}

resource "random_password" "my_secret_password" {
length           = 8
special          = true
override_special = "!@#$*"
}

resource "aws_secretsmanager_secret" "my_test_secret_1" {
name = "my_test_secret_1"
}

resource "aws_secretsmanager_secret_version" "my_test_secret_1_version" {
secret_id     = aws_secretsmanager_secret.my_test_secret_1.id
secret_string = random_password.my_secret_password.result

}
