output "endpoint" {
  value = aws_db_instance.mariadb_rds.endpoint
}

output "address" {
  value = aws_db_instance.mariadb_rds.address
}

output "port" {
  value = aws_db_instance.mariadb_rds.port
}

output "sg_id" {
  value = aws_security_group.rds_sg.id
}