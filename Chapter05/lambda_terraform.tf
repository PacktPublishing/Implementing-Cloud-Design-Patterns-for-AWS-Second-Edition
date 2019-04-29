resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.cloudpatterns_terraform_lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.cloudpatterns-codebuild.arn}"
}

/* resource "aws_lambda_function" "cloudpatterns_terraform_lambda" {
  filename      = "cloudpatterns-terraform-function.zip"
  function_name = "cloudpatterns_terraform_lambda"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "terraform.my_handler"
  runtime   = "python2.7"
} */ 

resource "aws_lambda_function" "cloudpatterns_terraform_lambda" {
  filename         = "cloudpatterns_lambda.zip"
  function_name    = "cloudpatterns_terraform_lambda"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "terraform.handler"
  runtime          = "python2.7"
  source_code_hash = "${base64sha256(file("cloudpatterns_lambda.zip"))}"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.cloudpatterns-codebuild.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.cloudpatterns_terraform_lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
#   filter_prefix       = "/"
    filter_suffix       = ".tfplan"
  }
}