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

provider "aws" {
  region     = "eu-west-3"
  access_key = var.access_key
  secret_key = var.access_secret_key
}

resource "aws_key_pair" "terraform" {
  key_name   = "terraform-key"
  public_key = file(var.public_ssh_key_filepath)
}