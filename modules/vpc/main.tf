resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = var.instance_tenancy

    tags = {
        Name = "${var.project}-vpc"
    }
}

resource "aws_subnet" "pub_subnet" {
    cidr_block = var.vpc_pub_subnet_cidr_block
    vpc_id = aws_vpc.my_vpc.id
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project}-pub-subnet"
    }
}

resource "aws_subnet" "pri_subnet" {
    cidr_block = var.vpc_pri_subnet_cidr_block
    vpc_id = aws_vpc.my_vpc.id
    availability_zone = "eu-north-1b"
    
    tags = {
      Name = "${var.project}-pri-subnet"
    }
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
      Name = "${var.project}-igw"
    }
}

resource "aws_default_route_table" "my_rt" {
    default_route_table_id = aws_vpc.my_vpc.main_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
}

resource "aws_route_table_association" "pub_subnet_association" {
    subnet_id = aws_subnet.pub_subnet.id
    route_table_id = aws_default_route_table.my_rt.id
}