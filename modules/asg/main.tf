resource "aws_launch_template" "lt-module" {
    name = var.lt_name

    image_id = var.ami
    instance_type = var.instance_type

    key_name = var.key_name

    user_data = base64encode(var.user_data)

    network_interfaces {
      device_index = 0
      associate_public_ip_address = var.associate_public_ip_address
      security_groups = [ var.lt_sg_id ]
    }

    tags = {
      Name = "${var.project}-lt"
    }
}

resource "aws_autoscaling_group" "asg_module" {
    vpc_zone_identifier = [ var.subnet1_id, var.subnet2_id]
    desired_capacity = var.desired_capacity
    min_size = var.min_size
    max_size = var.max_size

    launch_template {
      id = aws_launch_template.lt-module.id
      version = "$Latest"
    }
}