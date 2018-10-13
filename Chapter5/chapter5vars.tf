variable "vpc_id" {
  default = "vpc-1802fb62"
}

variable "default_security_group_id" {
  default = "sg-a94db7e3"
}

variable "aws_codecommit_repository_url" {
  default = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/cloudpatternsrepo.git"
}

variable "aws_subnet_ids" {
  default = ["subnet-447dd623", "subnet-476f170d"]
}
