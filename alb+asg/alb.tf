resource "aws_lb_target_group" "tf-mobile-tg" {
    name = var.mobile_tg_name
    port = 80
    protocol = "HTTP"
    target_type = var.instance_target_type
    vpc_id = aws_vpc.alb_vpc.id

    health_check {
      path = "/mobile/"
      port = var.helath_check_port
    }
}

resource "aws_lb_target_group" "tf-laptop-tg" {
    name = var.laptop_tg_name
    port = 80
    protocol = "HTTP"
    target_type = var.instance_target_type
    vpc_id = aws_vpc.alb_vpc.id

    health_check {
      path = "/laptop/"
      port = var.helath_check_port
    }
}

resource "aws_lb" "tf_alb" {
    name = var.alb_name
    internal = false
    load_balancer_type = var.lb_type
    security_groups = [ aws_security_group.my_alb_tf_sg.id ]
    subnets = [ aws_subnet.my_alb_tf_subnet_1.id, aws_subnet.my_alb_tf_subnet_2.id ]
    enable_deletion_protection = false

    tags = {
        env = var.env
    }
}

resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.tf_alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = var.default_action_type
      target_group_arn = aws_lb_target_group.tf-mobile-tg.arn
    }
}

resource "aws_lb_listener_rule" "mobile_listener" {
    listener_arn = aws_lb_listener.http_listener.arn
    priority = 100

    action {
      type = var.default_action_type
      target_group_arn = aws_lb_target_group.tf-mobile-tg.arn
    }

    condition {
      path_pattern {
        values = ["/mobile/*"] //try "/mobile*", then you don't have to use "/" after writing mobile in the alb dns
      }
    }
}

resource "aws_lb_listener_rule" "laptop_listener" {
    listener_arn = aws_lb_listener.http_listener.arn
    priority = 200

    action {
      type = var.default_action_type
      target_group_arn = aws_lb_target_group.tf-laptop-tg.arn
    }

    condition {
      path_pattern {
        values = ["/laptop/*"] //try "/laptop*", then you don't have to use "/" after writing laptop in the alb dns
      }
    }
}