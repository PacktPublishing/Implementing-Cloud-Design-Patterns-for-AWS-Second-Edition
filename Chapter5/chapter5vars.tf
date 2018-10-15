variable "vpc_id" {
  default = "vpc-1802fb62"
}

variable "default_security_group_id" {
  default = "sg-0e26af41562cd5e30"
}

variable "aws_codecommit_repository_url" {
  default = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/cloudpatternsrepo"
}

variable "aws_subnet_ids" {
  default = ["subnet-0dd41fca106a50ecc"]
}
