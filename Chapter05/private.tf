resource "aws_subnet" "cloudpatterns_private" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "172.31.96.0/20"
  map_public_ip_on_launch = false
}

resource "aws_eip" "natgw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "cloudpatterns_nat_gw" {
  allocation_id = "${aws_eip.natgw_eip.id}"
  subnet_id     = "${var.aws_public_subnet_id}"

}

resource "aws_route_table" "nat_route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.cloudpatterns_nat_gw.id}"
  }
  
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.cloudpatterns_private.id}"
  route_table_id = "${aws_route_table.nat_route_table.id}"
}

resource "aws_security_group" "nat_security_group" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}