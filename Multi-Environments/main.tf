provider "aws" {
    region = "eu-north-1"
}

resource "aws_instance" "multi_env_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name

    tags = {
      Name = "multi_env_instance"
      env = var.env
    }
}