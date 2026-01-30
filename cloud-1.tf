resource "aws_instance" "cloud-1" {
  ami                    = "ami-04df1508c6be5879e"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.terraform.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_https.id]

  provisioner "remote-exec" {
    inline = ["echo 'SSH is ready'"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.pvt_ssh_key_filepath)
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -i '${self.public_ip},' playbook.yml"
    working_dir = "./playbook"
    environment = {
      ANSIBLE_REMOTE_USER       = "ubuntu"
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_PRIVATE_KEY_FILE  = var.pvt_ssh_key_filepath
    }
  }
}

output "ssh_command" {
  value = "ssh -i ${var.pvt_ssh_key_filepath} ubuntu@${aws_instance.cloud-1.public_ip}"
}
