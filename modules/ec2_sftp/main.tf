


resource "aws_instance" "sftp_server" {
    ami = "ami-0279c3b3186e54acd"
    instance_type = "t2.micro"
   subnet_id = var.public_subnet[1]
    key_name = "demo"
    security_groups = [var.security_groups]

    
    tags = {
        Name = "sftp_server"
    }
}