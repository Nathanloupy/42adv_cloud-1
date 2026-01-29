resource "aws_instance" "cloud-1" {
  ami                    = "ami-04df1508c6be5879e"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.terraform.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
}

output "ssh_command" {
  value = "ssh -i ${var.pvt_ssh_key_filepath} ubuntu@${aws_instance.cloud-1.public_ip}"
}
