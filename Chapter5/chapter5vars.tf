variable "vpc_id" {
  default = "vpc-1802fb62"
}

variable "default_security_group_id" {
  default = "sg-0be574956123abb87"
}

variable "aws_codecommit_repository_url" {
  default = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/cloudpatternsrepo"
}

variable "aws_build_subnet_id" {
  default = ["subnet-034a9e5e46cce777c"]
}

variable "aws_public_subnet_id" {
  default = "subnet-476f170d"
}