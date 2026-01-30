resource "aws_instance" "cloud-1" {
  ami                    = "ami-04df1508c6be5879e"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.terraform.key_name
  subnet_id              = aws_subnet.public.id
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
    command     = <<-EOT
      ansible-playbook -i '${self.public_ip},' playbook.yml \
        -e 'mysql_root_password=${var.mysql_root_password}' \
        -e 'mysql_user=${var.mysql_user}' \
        -e 'mysql_password=${var.mysql_password}' \
        -e 'mysql_database=${var.mysql_database}' \
        -e 'wordpress_url=${var.wordpress_url}' \
        -e 'wordpress_title=${var.wordpress_title}' \
        -e 'wordpress_admin_user=${var.wordpress_admin_user}' \
        -e 'wordpress_admin_password=${var.wordpress_admin_password}' \
        -e 'wordpress_admin_email=${var.wordpress_admin_email}'
    EOT
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
