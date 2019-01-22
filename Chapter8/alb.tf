resource "aws_lb" "lambda-alb" {
  name               = "lambda-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-447dd623","subnet-476f170d"]
}

resource "aws_lb_target_group" "lambda-target-group" {
  name        = "alb-lambda-group"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "lamdba-target-attachment" {
  target_group_arn  = "${aws_lb_target_group.lambda-target-group.arn}"
  target_id         = "${aws_lambda_function.alb_terraform_lambda.arn}"
  depends_on        = ["aws_lambda_permission.iam_for_alb"]
}