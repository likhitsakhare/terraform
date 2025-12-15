variable "project" {}

variable "subnet_ids" {
    type = list(string)
}

variable "sg_description" {}

variable "default_vpc_id" {}

variable "engine_version" {}

variable "instance_class" {}

variable "allocated_storage" {}

variable "storage_type" {}

variable "db_name" {}

variable "username" {}

variable "password" {}

variable "port" {}

variable "publicly_accessible" {}

variable "backup_retention" {}