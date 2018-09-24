resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_vpc" "mainvpc_west" {
  provider = "aws.west"
  cidr_block = "10.1.0.0/16"
}
