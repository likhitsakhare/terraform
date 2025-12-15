resource "aws_lb_target_group" "tg-module" {
    name = var.tg_name
    port = var.port
    protocol = var.protocol
    target_type = var.instance_target_type
    vpc_id = var.vpc_id
}