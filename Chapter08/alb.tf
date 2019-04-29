resource "aws_lb" "lambda-alb" {
  name               = "lambda-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-447dd623","subnet-476f170d"]
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  
//    access_logs {
//    bucket  = "${aws_s3_bucket.lb_logs.bucket}"
//    prefix  = "test-lb"
//    enabled = true
//  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Load Balancer port 80"
//  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
// add logging policies


resource "aws_lb_listener" "alb_listener" {  
  load_balancer_arn = "${aws_lb.lambda-alb.arn}"  
  port              = "80"  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.lambda-target-group.arn}"
    type             = "forward"  
  }
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