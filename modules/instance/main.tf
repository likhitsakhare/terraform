resource "aws_instance" "my-module-instance" {
    ami = var.ami
    instance_type = var.instance_type
    associate_public_ip_address = true

    tags = {
        Name = "${var.project}-instance"
    }
}