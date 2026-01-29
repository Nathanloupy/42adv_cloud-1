resource "aws_instance" "cloud-1" {
  ami           = "ami-04df1508c6be5879e"
  instance_type = "t3.micro"

  tags = {
    Name = "cloud-1"
  }
}
