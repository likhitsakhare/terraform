provider "aws" {
    region = var.region
}

resource "aws_launch_template" "mobile" {
    name = "mobile"

    image_id = var.ami
    instance_type = var.instance_type

    key_name = var.key_pair

    user_data = base64encode(<<EOF
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
mkdir -p /var/www/html/mobile/
echo "<h1> Hello world </h1>" > /var/www/html/mobile/index.html
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
)
    //vpc_security_group_ids = [ aws_security_group.my_launch_template_sg.id ]

    network_interfaces {
      associate_public_ip_address = true
      security_groups = [ aws_security_group.my_launch_template_sg.id ]
    }

    tags = {
        evn = var.env
    }
}

resource "aws_launch_template" "laptop" {
    name = "laptop"

    image_id = var.ami
    instance_type = var.instance_type

    key_name = var.key_pair

    user_data = base64encode(<<EOF
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
mkdir -p /var/www/html/laptop/
echo "<h1> Hello world </h1>" > /var/www/html/laptop/index.html
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
)

    //vpc_security_group_ids = [ aws_security_group.my_launch_template_sg.id ]

    network_interfaces {
      associate_public_ip_address = true
      security_groups = [ aws_security_group.my_launch_template_sg.id ]
    }

    tags = {
        evn = var.env
    }
}

resource "aws_autoscaling_group" "tf_mobile_asg" {
    vpc_zone_identifier = [ aws_subnet.my_alb_tf_subnet_1.id, aws_subnet.my_alb_tf_subnet_2.id ]
    desired_capacity = 1
    min_size = 1
    max_size = 2

    launch_template {
      id = aws_launch_template.mobile.id
      version = "$Latest"
    }

    target_group_arns = [ aws_lb_target_group.tf-mobile-tg.arn ]
}

resource "aws_autoscaling_group" "tf_laptop_asg" {
    vpc_zone_identifier = [ aws_subnet.my_alb_tf_subnet_1.id, aws_subnet.my_alb_tf_subnet_2.id ]
    desired_capacity = 1
    min_size = 1
    max_size = 2

    launch_template {
      id = aws_launch_template.laptop.id
      version = "$Latest"
    }

    target_group_arns = [ aws_lb_target_group.tf-laptop-tg.arn ]
}