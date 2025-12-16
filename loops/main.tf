provider "aws" {
    region = "eu-north-1"
}

//count
resource "aws_instance" "my_instance" {
    ami = "ami-0fa91bc90632c73c9"
    instance_type = "t3.micro"
    key_name = "likhit_key_pair"
    count = 2

    tags = {
      Name = "loop_instance_${count.index}"
    }
}

//for_each
resource "aws_instance" "my_instance" {
    ami = each.value
    for_each = toset(var.ami_ids)
    instance_type = "t3.micro"
    key_name = "likhit_key_pair"
    count = 2

    tags = {
      Name = "loop_instance_${count.index}"
    }
}

variable "ami_ids" {
  default = ["ami-0fa91bc90632c73c9", "ami-0b46816ffa1234887", "ami-08526b399bb6eb2c7"]
}

//for
output "public_ip" {
  value = {for id, instance in aws_instance.my_instance : id => instance.public_ip}
}