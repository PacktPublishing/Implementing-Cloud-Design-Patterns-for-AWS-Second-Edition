# Virginia
# Request a spot instance at $0.0036
resource "aws_spot_instance_request" "cheap_worker" {
  # the below ami is for the latest Bitnami Wordpress East
  ami           = "ami-001e1c1159ccfe992"
  spot_price    = "0.0035"
  instance_type = "t2.micro"
  availability_zone  = "us-east-1d"

  tags {
    Name = "CheapWorker"
  }
}
output "id" {
  value = "${aws_spot_instance_request.cheap_worker.spot_instance_id}"
}

# Oregon
# Request another spot instance at $0.0036
resource "aws_spot_instance_request" "cheap_worker_west" {
  # the below ami is for the latest Bitnami Wordpress West
  ami           = "ami-000ce50ab0df5943f"
  provider = "aws.west"
  spot_price    = "0.0036"
  instance_type = "t2.micro"
  availability_zone  = "us-west-1d"

  tags {
    Name = "CheapWorker"
  }
}
output "id_west" {
  value = "${aws_spot_instance_request.cheap_worker_west.spot_instance_id}"
}