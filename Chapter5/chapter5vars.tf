variable "vpc_id" {
  default = "vpc-1802fb62"
}

variable "default_security_group_id" {
  default = "sg-0be574956123abb87"
}

variable "aws_codecommit_repository_url" {
  default = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/cloudpatternsrepo"
}

variable "aws_subnet_ids" {
  default = ["subnet-034a9e5e46cce777c"]
}
