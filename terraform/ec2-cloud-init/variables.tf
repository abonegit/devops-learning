variable "aws_region" {
  description = "AWS region for the EC2 deployment"
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
  default     = "ec2-cloud-init"
}
