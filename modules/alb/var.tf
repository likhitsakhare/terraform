variable project {}

variable "internal" {
  type = bool
}

variable "lb_type" {}

variable "alb_sg_id" {}

variable "subnet1" {}

variable "subnet2" {}

variable "deletion_protection" {
  type = bool
}

variable "default_tg_arn" {}