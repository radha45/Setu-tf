data "aws_subnet_ids" "subnets" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    type = "public"
  }
 depends_on = [aws_subnet.public_subnet]

}

data "aws_subnet_ids" "private-subnets" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    type = "private"
  }
 depends_on = [aws_subnet.private_subnet]

}

resource "aws_lb" "elb" {
  name               = "${var.project}-application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-elb.id]
  subnets            = data.aws_subnet_ids.subnets.ids
  tags = {
    Name      = "${var.project}-Application Load Balancer"
    project   = var.project
    managedBy = "terraform"
  }
}

resource "aws_lb_target_group" "target_group" {
  name_prefix        = "${var.project}"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    path                = var.health_check_path
    port                = var.health_check_port
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200" # has to be HTTP 200 or fails
  }
  stickiness {
    type = "lb_cookie"
  }
  lifecycle {
      create_before_destroy = true
    }
  tags = {
    project   = var.project
    managedBy = "terraform"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Path"
      status_code  = "404"
    }
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  listener_arn = aws_lb_listener.http.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_security_group" "sg-elb" {
  name        = "${var.project}-ELB"
  description = "Allow traffic on port 443 for api traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = "${var.project}-ALB-sg"
    project   = var.project
    managedBy = "terraform"
  }
}
