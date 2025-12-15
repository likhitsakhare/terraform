resource "aws_lb" "module-alb" {
    name = "${var.project}-alb"
    internal = var.internal
    load_balancer_type = var.lb_type
    security_groups = [ var.alb_sg_id ]
    subnets = [ var.subnet1, var.subnet2 ]
    enable_deletion_protection = var.deletion_protection

    tags = {
      Name = "${var.project}-alb"
    }
}

resource "aws_lb_listener" "http_listener_module" {
    load_balancer_arn = aws_lb.module-alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = var.default_tg_arn
    }
}