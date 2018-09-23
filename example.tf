provider "aws" {

  region     = "us-east-1"
}
resource "aws_instance" "example" {
  ami = "ami-2757f631"
  instance_type = "t2.micro"
  availability_zone  = "us-east-1f"
}
output "id" {
  value = "${aws_instance.example.id}"
}