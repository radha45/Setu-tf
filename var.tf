
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
variable "key_pair"{default="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcYbGVDmJatdd6FfbKbLUAlk+shybq0gZhzS4HY26uMwFlULJXPOYAVAi05BLMioBFSMqYMWDDsC4+E96D9tTO/aZD/MAmgbF8LN6r+Ku9mgIQy47uoUNPBYX5EI8RsY/7LbTILAxvvOQn0btXSDFQ0hpX22REWQGJUyvfASVEP8yLl836o35WvJTHOihv8om/NCeU4+4tr8Eu4z3QMGXJJXCLP0fyizJ2/2eOF2s9EV5AkF96DMj2Cp5vKIPef4EvgPkmUF5O5IbIN2XYBZy4gAENMhM0loBN4IkHiZ3/uT8jYQq1FLKBLpiB/1UmMTRWDkPc1pN9FnDz8zKcEtUx/ikzkiUTPnF5XLzIH/0jMrG/a1fUIlz6p1pDcdmM3hEsxUnCfhdUKaNfyFFAN1hPVDb/wZroh96HttQPTauvDwsyca+9CzR1p9721umnpI1pAy2Nzb/2CoVuZLjM4DmuS4a2XHORo5JPafuZSFOs9NN/KzVF/8mmQSZcluE7H08= radha@AAD-9Q5SXD3"}
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
