terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_key_pair" "ansible" {
  key_name   = "ansible"
  public_key = file("keys/thong-bot-tokyo.pub")
}

resource "aws_instance" "backtest_cnews" {
  count = var.backtest_ec2_count

  ami           = "ami-0a2e10c1b874595a1"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ansible.key_name
  subnet_id = "subnet-05a19258c38f50fa7"
  vpc_security_group_ids = ["sg-04d7709abccbeb5ce"]
  associate_public_ip_address = "true"

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "backtest-cnews-${count.index}"
  }
}