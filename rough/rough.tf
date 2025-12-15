provider "aws" {
    region = "eu-north-1"
}

resource "aws_instance" "my_tf_instance" {
    ami = "ami-0fa91bc90632c73c9"
    instance_type = "t3.micro"
    key_name = "likhit_key_pair"

    vpc_security_group_ids = [ aws_security_group.my_tf_sg.id ]
    subnet_id = aws_subnet.my_tf_subnet_1.id

    tags = {
        Name = "my_tf_instance"
        env = "dev"
    }

    user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    echo "This instance was created using terraform" > /var/www/html/index.html
    sudo systemctl start nginx
    sudo systemctl enable nginx
    EOF
}

resource "aws_vpc" "my_tf_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "my_tf_vpc"
        env = "dev"
    }
}

resource "aws_subnet" "my_tf_subnet_1" {
    vpc_id = aws_vpc.my_tf_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-north-1a"

    tags = {
      Name = "my_tf_subnet_1"
      env = "dev"
    }
}

resource "aws_subnet" "my_tf_subnet_2" {
    vpc_id = aws_vpc.my_tf_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-north-1b"

    tags = {
      Name = "my_tf_subnet_2"
      env = "dev"
    }
}


resource "aws_security_group" "my_tf_sg" {
    name = "allow_http"
    description = "Allows the 80 i.e. HTTP port"
    vpc_id = aws_vpc.my_tf_vpc.id

    tags = {
        Name = "my_tf_sg"
        env = "dev"
    }

    ingress {
        from_port = 80
        protocol = "tcp"
        to_port = 80
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_s3_bucket" "my_tf_bucket" {
    bucket = "my-bucket-likhit-1181"

    tags = {
        Name = "my-tf-bucket"
        evn = "dev"
    }
}

resource "aws_s3_object" "upload_file" {
    bucket = aws_s3_bucket.my_tf_bucket.bucket
    key = "new_file"
    source = "C:\\Users\\sakha\\Downloads\\index.html.txt"
}