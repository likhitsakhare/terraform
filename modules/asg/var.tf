variable "project" {}

variable "lt_name" {}

variable "ami" {} 

variable "instance_type" {} 

variable "key_name" {}

variable "user_data" {}

variable "associate_public_ip_address" {
  type = bool
}

variable "lt_sg_id" {}

variable "subnet1_id" {}

variable "subnet2_id" {}

variable "desired_capacity" {}

variable "min_size" {}

variable "max_size" {}