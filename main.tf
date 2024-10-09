resource "aws_instance" "app_server" {
  ami           = "ami-06f855639265b5541"
  instance_type = "t2.micro"

  tags = {
    Name = "zesn-ec2"
  }
}