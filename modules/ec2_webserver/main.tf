

resource "aws_instance" "web_server" {
    ami = "ami-0279c3b3186e54acd"
    instance_type = "t2.micro"
    subnet_id = var.public_subnet[1]
    key_name = "demo"
    security_groups = [var.security_groups]

    user_data = <<-EOF
        #! /bin/bash
        sudo apt-get update
        sudo apt-get install -y nginx
        sudo systemctl start nginx
        sudo systemctl enable nginx
     EOF
    
    tags = {
        Name = "web_server"
    }
}


