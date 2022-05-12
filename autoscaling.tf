resource "aws_key_pair" "tf" {
  key_name   = "tf-key"
  public_key = var.key_pair
}



resource "aws_security_group" "pub-instance" {
  name                                      = "${var.project}-pub-instance"
  description                               = "${var.project} pub instance security group"
  vpc_id                                    = aws_vpc.vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
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
    Name      = "${var.project}-sg-instance"
    project   = var.project
    managedBy = "terraform"
  }

}


resource "aws_launch_template" "public" {
  name                                      = "${var.project}-launch-config"
  disable_api_termination                   = var.disable_api_termination
  image_id                                  = var.instance_ami
  instance_type                             = var.instance_type
  key_name                                  = aws_key_pair.tf.key_name
  user_data = "${base64encode(<<EOF
  #!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
)}"

  network_interfaces {
    associate_public_ip_address = true
     security_groups             =    [aws_security_group.pub-instance.id]
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"



  tags = {
    Name      = "${var.project}-lauch-config-pub"
    project   = var.project
    managedBy = "terraform"
  }

  }


}


resource "aws_autoscaling_group" "public" {
  name_prefix                                      = "${var.project}-pub-asg"
  vpc_zone_identifier                       = data.aws_subnet_ids.subnets.ids
  desired_capacity                          = var.instance_desired_cap
  max_size                                  = var.instance_max_cap
  min_size                                  = var.instance_min_cap
  health_check_type                         = var.health_check_type
  target_group_arns                         = [aws_lb_target_group.target_group.arn]


  launch_template {
    id      = aws_launch_template.public.id
    version = "$Latest"
  }

   tags = [{
    Name      = "${var.project}-asg-pub"
    project   = var.project
    managedBy = "terraform"
  }]
}

resource "aws_security_group" "private-instance" {
  name                                      = "${var.project}-private-instance"
  description                               = "${var.project} private instance security group"
  vpc_id                                    = aws_vpc.vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = ["${aws_security_group.pub-instance.id}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    security_groups = ["${aws_security_group.pub-instance.id}"]
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

tags = {
    Name      = "${var.project}-sg-instance"
    project   = var.project
    managedBy = "terraform"
  }

}

resource "aws_launch_template" "private" {
  name                                      = "${var.project}-private-launch-config"
  disable_api_termination                   = var.disable_api_termination
  image_id                                  = var.instance_ami
  instance_type                             = var.instance_type
  key_name                                  = aws_key_pair.tf.key_name

  network_interfaces {
    associate_public_ip_address = false
     security_groups             =    [aws_security_group.private-instance.id]
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"



  tags = {
    Name      = "${var.project}-lauch-config-private"
    project   = var.project
    managedBy = "terraform"
  }

  }


}

resource "aws_autoscaling_group" "private" {
  name_prefix                                      = "${var.project}-private-asg"
  vpc_zone_identifier                       = data.aws_subnet_ids.private-subnets.ids
  desired_capacity                          = var.instance_desired_cap
  max_size                                  = var.instance_max_cap
  min_size                                  = var.instance_min_cap
  health_check_type                         = var.health_check_type


  launch_template {
    id      = aws_launch_template.private.id
    version = "$Latest"
  }

   tags = [{
    Name      = "${var.project}-asg-private"
    project   = var.project
    managedBy = "terraform"
  }]
}

