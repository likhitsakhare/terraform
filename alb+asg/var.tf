variable "region" {
   default = "eu-north-1"
}

variable "ami" {
    default = "ami-0fa91bc90632c73c9"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "key_pair" {
    default = "likhit_key_pair"
}

variable "env" {
    default = "dev"
}

variable "az-1a" {
    default = "eu-north-1a"
}

variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "instance_tenancy" {
    default = "default"
}

variable "subnet1_cidr_block" {
    default = "10.0.1.0/24"
}

variable "subnet2_cidr_block" {
    default = "10.0.2.0/24"
}

variable "az-1b" {
    default = "eu-north-1b"
}

variable "alb_sg_name" {
    default = "allow_http and ssh"
}

variable "alb_sg_desc" {
    default = "Allows the 80 i.e. HTTP port and 22 i.e. SSH port"
}

variable "lt_sg_name" {
    default = "allow http and ssh"
}

variable "lt_sg_desc" {
    default = "Allows the 80 i.e. HTTP port from sg of alb and 22 i.e. SSH port"
}

variable "all_traffic_cidr" {
    default = "0.0.0.0/0"
}

variable "mobile_tg_name" {
    default = "my-mobile-tf-tg"
}

variable "laptop_tg_name" {
    default = "my-laptop-tf-tg"
}

variable "instance_target_type" {
    default = "instance"
}

variable "helath_check_port" {
    default = "traffic-port"
}

variable "alb_name" {
    default = "my-tf-alb"
}

variable "lb_type" {
    default = "application"
}

variable "default_action_type" {
    default = "forward"
}