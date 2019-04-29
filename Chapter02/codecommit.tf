provider "aws" {

  region     = "us-east-1"
}
data "aws_codecommit_repository" "cloudpatterns" {
  repository_name = "cloudpatternsrepo"
}