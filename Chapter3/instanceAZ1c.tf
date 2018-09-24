# Virginia 1c
resource "aws_instance" "cheap_worker1c" {
  # the below ami is for the latest Bitnami Wordpress East
  ami           = "ami-001e1c1159ccfe992"
  instance_type = "t2.micro"
  availability_zone  = "us-east-1c"

  tags {
    Name = "CheapWorker"
  }
}
output "id1c" {
  value = "${aws_instance.cheap_worker1c.id}"
}