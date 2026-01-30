terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

variable "access_key" {}
variable "access_secret_key" {}
variable "public_ssh_key_filepath" {}
variable "pvt_ssh_key_filepath" {}
variable "allowed_ssh_ip" {}

provider "aws" {
  region     = "eu-west-3"
  access_key = var.access_key
  secret_key = var.access_secret_key
}

resource "aws_key_pair" "terraform" {
  key_name   = "terraform-key"
  public_key = file(var.public_ssh_key_filepath)
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ssh_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_https" {
  name = "allow_https"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
