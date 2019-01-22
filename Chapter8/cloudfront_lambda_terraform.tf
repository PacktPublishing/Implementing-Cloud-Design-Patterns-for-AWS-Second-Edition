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
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "edgelambda.amazonaws.com"
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
  function_name = "${aws_lambda_function.cloudfront_terraform_lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.cloudpatterns-cloudfrontbucket.arn}"
}

resource "aws_lambda_permission" "allow_cloudfront" {
  statement_id   = "AllowExecutionFromCloudFront"
  action         = "lambda:GetFunction"
  function_name = "${aws_lambda_function.cloudfront_terraform_lambda.arn}"
  principal      = "edgelambda.amazonaws.com"
}

resource "aws_lambda_function" "cloudfront_terraform_lambda" {
  filename         = "cloudfront_lambda.zip"
  function_name    = "cloudfront_terraform_lambda"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "terraform.handler"
  runtime          = "nodejs8.10"
  source_code_hash = "${base64sha256(file("cloudfront_lambda.zip"))}"
  publish          = "true"
}