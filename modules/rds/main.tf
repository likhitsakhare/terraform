resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "${var.project}-rds-subnet-group"
    subnet_ids = var.subnet_ids

    tags = {
      Name = "${var.project}-rds-subnet-group"
    }
}

resource "aws_security_group" "rds_sg" {
    name = "${var.project}-rds-sg"
    description = var.sg_description
    vpc_id = var.default_vpc_id

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = var.port
        protocol = "tcp"
        to_port = var.port
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }

    tags = {
      Name = "${var.project}-rds-sg"
    }
}

resource "aws_db_instance" "mariadb_rds" {
    identifier = "${var.project}-mariadb"
    engine = "mariadb"
    engine_version = var.engine_version
    instance_class = var.instance_class
    allocated_storage = var.allocated_storage
    storage_type = var.storage_type
    db_name = var.db_name
    username = var.username
    password = var.password
    port = var.port

    skip_final_snapshot = true
    publicly_accessible = var.publicly_accessible
    vpc_security_group_ids = [ aws_security_group.rds_sg.id ]
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    multi_az = false
    backup_retention_period = var.backup_retention
    deletion_protection = false

    tags = {
      Name = "${var.project}-mariadb"
    }
}