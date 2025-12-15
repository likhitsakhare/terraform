provider "aws" {
    region = var.region
}

/* module "vpc" {
    source = "./modules/vpc"

    project = "likhit-module"
    vpc_cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    vpc_pub_subnet_cidr_block = "10.0.1.0/24"
    vpc_pri_subnet_cidr_block = "10.0.2.0/24"
} */

/* module "instance" {
    source = "./modules/instance"

    project = "likhit-module"
    ami = "ami-0fa91bc90632c73c9"
    instance_type = "t3.micro"
} */

/* module "rds" {
    source = "./modules/rds"

    project = "my-rds"
    subnet_ids = ["subnet-02aefaf09cde58aa8", "subnet-09c3973cc7ae30024"]
    sg_description = "Allows 3306 port"
    default_vpc_id = "vpc-08b3e84882686af7e"
    engine_version = "11.4.3"
    instance_class = "db.t3.micro"
    allocated_storage = 20
    storage_type = "gp2"
    db_name = "my-mariadb"
    username = "admin"
    password = "Redhat123"
    port = 3306
    publicly_accessible = true
    backup_retention = 3
}
 */
/* module "tg1" {
    source = "./modules/tg"

    tg_name = "mobile"
    port = 80
    protocol = "HTTP"
    instance_target_type = "instance"
    vpc_id = ""
}

module "tg2" {
    source = "./modules/tg"

    tg_name = "laptop"
    port = 80
    protocol = "HTTP"
    instance_target_type = "instance"
    vpc_id = ""
}
 */
/* module "alb" {
    source = "./modules/alb"

    project = "my-module-alb"
    internal = false
    lb_type = "application"
    alb_sg_id = ""
    subnet1 = ""
    subnet2 = ""
    deletion_protection = false
    default_tg_arn = module.tg2.tg_arn
} */

/* module "asg" {
    source = "./modules/asg"

    project = "my-module-asg"
    lt_name = "mobile"
    ami = ""
    instance_type = "t3.micro"
    key_name = "likhit_key_pair"
    user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
mkdir -p /var/www/html/mobile/
echo "<h1> Hello world </h1>" > /var/www/html/mobile/index.html
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
    associate_public_ip_address = true
    lt_sg_id = ""
    subnet1_id = ""
    subnet2_id = ""
    desired_capacity = 1
    min_size = 1
    max_size = 2
} */

