
variable "project" {
  type        = string
  default     = "Setu"
  description = "Name of the project"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "The list of public subnet ranges. ex. ['10.0.0.0/24']"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "The list of private subnet ranges. ex. ['10.0.0.0/24']"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the vpc"
}


variable "delete_protection" {
  type        = bool
  default     = true
  description = "To enable delete protection for a resource"
}
variable "disable_api_termination"                                    {default = false}
variable "ebs_optimized"                                              {default = true}
variable "instance_ami"                                               {default = "ami-0fa49cc9dc8d62c84"}
variable "instance_type"                                              {default = "t2.micro"}
variable "key_pair"{default="key"}
variable "associate_public_ip_address_pub"                                {default = true}
variable "instance_desired_cap"  {default =2}
variable "instance_max_cap" {default = 2}
variable "instance_min_cap"{default =2}
variable "health_check_type"                                          {default = "EC2"}
variable "health_check_path" {
  type        = string
  default     = "/"
  description = "health check path for target group"
}
variable "health_check_port" {
  type        = string
  default     = "80"
  description = "health check port for target group"
}
variable "identifier"{default ="setudb"}
variable "allocated_storage"{default =20}
variable "storage_type"{default ="gp2"}
variable "engine"{
default ="mysql"
}
variable "engine_version"{default ="5.7"}
variable "instance_class"{default ="db.t2.medium"}
variable "name"{default ="Setudb"}
variable "username"{default ="dbadmin"}
