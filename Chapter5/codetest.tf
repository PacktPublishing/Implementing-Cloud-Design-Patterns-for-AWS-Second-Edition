resource "aws_codebuild_project" "cloudpatterns-codetest" {
  name         = "cloudpatterns-project"
  description  = "cloudpatterns_codebuild_project"
  build_timeout      = "5"
  service_role = "${aws_iam_role.cloudpatterns-codebuild.arn}"

  artifacts {
    type = "S3"
    location = "${aws_s3_bucket.cloudpatterns-codebuild.bucket}"
  }

/*  cache {
    type     = "S3"
    location = "${aws_s3_bucket.cloudpatterns-codebuild.bucket}"
  } */

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ubuntu-base:14.04"
    type         = "LINUX_CONTAINER"
  }

  source {
    type            = "CODECOMMIT"
    location        = "${var.aws_codecommit_repository_url}"
#   auth            = {type = "OAUTH"}
    git_clone_depth = 1
  }

  vpc_config {
    vpc_id = "${var.vpc_id}"

    subnets = [
      "${var.aws_build_subnet_id}",
    ]

    security_group_ids = [
      "${var.default_security_group_id}",
    ]
  }

  tags {
    "Environment" = "cloudpatterns"
  }
}