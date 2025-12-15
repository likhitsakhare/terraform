provider "aws" {
    region = "eu-north-1"
}

#Instance
resource "aws_instance" "main_instance" {
    ami = "ami-0fa91bc90632c73c9"
    instance_type = "t3.micro"
    vpc_security_group_ids = [ aws_security_group.tf_instance_sg.id ]
    subnet_id = aws_subnet.main_subnet1.id
    associate_public_ip_address = true

    tags = {
      Name = "terraform instance"
    }
}