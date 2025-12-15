provider "aws" {
    region = "eu-north-1"
}

resource "aws_instance" "my_instance" {
    ami = "ami-0b46816ffa1234887" //"ami-0fa91bc90632c73c9"
    instance_type = "t3.micro"
    key_name = "likhit_key_pair"
    vpc_security_group_ids = [ aws_security_group.my_sg.id ]
    associate_public_ip_address = true
    subnet_id = "subnet-09c3973cc7ae30024"

    user_data = base64encode(<<EOF
#!/bin/bash
sudo yum update -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
)

    tags = {
      Name = "Provisioner Instance"
    }

    provisioner "remote-exec" {
      inline = [ "sleep 40" ]
    }

    provisioner "file" {
      source = "index.html"
      destination = "/tmp/index.html"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo mv /tmp/index.html /usr/share/nginx/html/index.html"
      ]
    }

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("likhit_key_pair.pem")
      host = self.public_ip
    }
}

resource "aws_security_group" "my_sg" {
    name = "allow ssh"
    description = "Allows 22 i.e. SSH port"
    vpc_id = "vpc-08b3e84882686af7e"

    tags = {
      Name = "allow ssh"
    }

    ingress {
        from_port = 22
        protocol = "tcp"
        to_port = 22
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}