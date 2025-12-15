provider "aws" {
    region = "eu-north-1"
}

#VPC
resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "terraform vpc"
    }
}

#Security group
resource "aws_security_group" "tf_instance_sg" {
    name = "allow_http"
    description = "Allows the 80 i.e. HTTP port"
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "allow_http"
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

#Subnet 1
resource "aws_subnet" "main_subnet1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "terraform subnet 1"
    }
}

#Subnet 2 
resource "aws_subnet" "main_subnet2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-north-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "terraform subnet 2"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "terraform igw"
    }
}

#Main route table from console
data "aws_route_table" "main_rt" {
    vpc_id = aws_vpc.main_vpc.id
}

# Add the route of IGW to the route table
resource "aws_route" "igw_route" {
    route_table_id = data.aws_route_table.main_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
}

#Subnet1 association with the main route table from console
resource "aws_route_table_association" "subnet1_association" {
    subnet_id = aws_subnet.main_subnet1.id
    route_table_id = data.aws_route_table.main_rt.id
}

#Subnet2 association with the main route table from console
resource "aws_route_table_association" "subnet2_association" {
    subnet_id = aws_subnet.main_subnet2.id
    route_table_id = data.aws_route_table.main_rt.id
}