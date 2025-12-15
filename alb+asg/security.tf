resource "aws_vpc" "alb_vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = var.instance_tenancy

    tags = {
      env = var.env
    }
}

resource "aws_internet_gateway" "alb_vpc_igw" {
    vpc_id = aws_vpc.alb_vpc.id

    tags = {
        env = var.env
    }
}

resource "aws_subnet" "my_alb_tf_subnet_1" {
    vpc_id = aws_vpc.alb_vpc.id
    cidr_block = var.subnet1_cidr_block
    availability_zone = var.az-1a

    tags = {
      env = var.env
    }
}

resource "aws_subnet" "my_alb_tf_subnet_2" {
    vpc_id = aws_vpc.alb_vpc.id
    cidr_block = var.subnet2_cidr_block
    availability_zone = var.az-1b

    tags = {
      env = var.env
    }
}

data "aws_route_table" "main_alb_rt" {
    vpc_id = aws_vpc.alb_vpc.id
}

resource "aws_route" "igw_route" {
    route_table_id = data.aws_route_table.main_alb_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.alb_vpc_igw.id
}

resource "aws_route_table_association" "alb_subnet1_association" {
    subnet_id = aws_subnet.my_alb_tf_subnet_1.id
    route_table_id = data.aws_route_table.main_alb_rt.id
}

resource "aws_route_table_association" "alb_subnet2_association" {
    subnet_id = aws_subnet.my_alb_tf_subnet_2.id
    route_table_id = data.aws_route_table.main_alb_rt.id
}

resource "aws_security_group" "my_launch_template_sg" {
    name = var.lt_sg_name
    description = var.lt_sg_desc
    vpc_id = aws_vpc.alb_vpc.id

    tags = {
        env = var.env
    }

    ingress {
        from_port = 22
        protocol = "tcp"
        to_port = 22
        cidr_blocks = [ var.all_traffic_cidr ]
    }

    ingress {
        from_port = 80
        protocol = "tcp"
        to_port = 80
        security_groups = [ aws_security_group.my_alb_tf_sg.id ]
    }

    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = [ var.all_traffic_cidr ]
    }
}

resource "aws_security_group" "my_alb_tf_sg" {
    name = var.alb_sg_name
    description = var.alb_sg_desc
    vpc_id = aws_vpc.alb_vpc.id

    tags = {
        env = var.env
    }

    ingress {
        from_port = 80
        protocol = "tcp"
        to_port = 80
        cidr_blocks = [ var.all_traffic_cidr ]
    }

    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = [ var.all_traffic_cidr ]
    }
}