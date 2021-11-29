
output "security_groups_sftp" {
  
  value = aws_security_group.sftp_sg.id
}

output "security_groups_webserver" {
  
  value = aws_security_group.webserver_sg.id

}

output "security_groups_worker" {
  value = aws_security_group.worker_sg.id

}