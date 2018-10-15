resource "aws_s3_bucket" "cloudpatterns-codebuild" {
  bucket = "cloudpatterns-codebuild"
  acl    = "private"
  
  versioning {
    enabled = true
  }
}

data "aws_subnet_ids" "example" {
  vpc_id = "${var.vpc_id}"
}

resource "aws_iam_role" "cloudpatterns-codebuild" {
  name = "cloudpatterns-codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudpatterns-codebuild" {
  role        = "${aws_iam_role.cloudpatterns-codebuild.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codecommit:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.cloudpatterns-codebuild.arn}",
        "${aws_s3_bucket.cloudpatterns-codebuild.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "cloudpatterns-codebuild" {
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
      buildspec = "sonarqube.yml"
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