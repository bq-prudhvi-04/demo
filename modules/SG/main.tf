

resource "aws_security_group" "sftp_sg" {
  name   = "sftp_server_sg"
  vpc_id = var.vpc_id

 tags = {
    Name = "sftp_server_sg"
  }

}

# Ingress Security Port 220
resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = 220
  protocol          = "tcp"
  security_group_id = aws_security_group.sftp_sg.id
  to_port           = 220
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}



# All OutBound Access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sftp_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}



resource "aws_security_group" "webserver_sg" {
  name        = "web_server_sg"
  vpc_id      = var.vpc_id

  ingress {
    
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

   ingress {
    
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "web_server_sg"
  }
}


resource "aws_security_group" "worker_sg" {
  name        = "woker_sg"
  vpc_id      = var.vpc_id

  ingress {
    
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "worker_sg"
  }
}