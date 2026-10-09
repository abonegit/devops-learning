variable "aws_region" {
  description = "AWS region where the WordPress infrastructure will be deployed"
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "EC2 instance type for the WordPress server"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the WordPress EC2 instance"
  type        = string
  default     = "wordpress-server"
}
