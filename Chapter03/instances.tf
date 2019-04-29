# Virginia
resource "aws_instance" "cheap_worker" {
  # the below ami is for the latest Bitnami Wordpress East
  ami           = "ami-001e1c1159ccfe992"
  instance_type = "t2.micro"
  availability_zone  = "us-east-1d"
  associate_public_ip_address = true

  tags {
    Name = "CheapWorker"
  }
}
output "id" {
  value = "${aws_instance.cheap_worker.id}"
}
output "ip" {
  value = "${aws_instance.cheap_worker.public_ip}"
}

# Oregon
resource "aws_instance" "cheap_worker_west" {
  # the below ami is for the latest Bitnami Wordpress West
  ami           = "ami-000ce50ab0df5943f"
  provider = "aws.west"
  instance_type = "t2.micro"
  availability_zone  = "us-west-2c"
  associate_public_ip_address = true

  tags {
    Name = "CheapWorker"
  }
}
output "id_west" {
  value = "${aws_instance.cheap_worker_west.id}"
}
output "ip_west" {
  value = "${aws_instance.cheap_worker_west.public_ip}"
}