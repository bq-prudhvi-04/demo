# vpc 
create vpc with 3 public and private subnets
public subnets are attached to default route table and internet gate way is attched to it

private subnets are attached to private route table and nat gateway is attched for internet connection.

# security groups 
 for sftp server inboud rule port 220 is opened

 for webserver inbound rule port 80 and 443 is opened

 for worker inbound rule port 22 is opened

 for all above security groups outbound all ports are opened


# Sftp_server
i created frist sftp server in ec2 instance by adding new user and group and added some configuration lines to /etc/ssh/sshd_config file 

The extra lines are 

Match group sftp_fosslinux 
ChrootDirectory /home 
X11Forwarding no 
AllowTcpForwarding no 
ForceCommand internal-sftp

from that ec2 intance i have craeted ami and used that ami to create sftp server

# web server

i created a auto scaling group with launch template with pre defined user data that as nginx web server intalled


# workers 
created with auto scaling group with image ubuntu:18.04 version

# sqs
 default values 

# sns
crtead one topic and one subcription

# cloud watch 

created dashboard with cpu utilization metric

