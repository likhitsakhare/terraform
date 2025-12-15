output "alb_dns_name" {
  value = aws_lb.module-alb.dns_name
}

output "alb_arn" {
  value = aws_lb.module-alb.arn
}

output "tg_arn" {
  value = module.tg.tg_arn
}