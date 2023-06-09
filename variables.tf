data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.202*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

variable "aws_region" {
  type        = string
  description = "AWS region to create resources in."
  default     = "us-east-2"
}
