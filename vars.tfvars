public_subnet_cidrs  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
private_subnet_cidrs = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
vpc_cidr             = "10.0.0.0/16"
disable_api_termination = false
ebs_optimized = true
instance_ami = "ami-0fa49cc9dc8d62c84"
instance_type= "t2.micro"