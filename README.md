# Prerequisites
knowledge in AWS cloud and Terraform modules 
Terraform version used is v1.0.11

 # Installation instructions
download terraform from the official site based on your platform, in this project ubuntu:18.04 version is used. 
in ubuntu installation steps fallows
1) wget https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
2) unzip terraform_1.0.11_linux_amd64.zip
3) mv terraform /usr/bin/
 check for terraform version   
4)terraform version

# How to run the project 
create a workspace or a folder and copy the above code to that folder
first configure the AWS credentials in your server or directly pass credentials in the AWS provider section in main.tf file 

run terraform init command which downloads plugins related to AWS provider to initialize the workspace

run terraform life cycle commands and terraform apply command it will create following resources.
 
# vpc 
creates a new vpc with 3 public and private subnets

public subnets are attached to the default route table and the internet gateway is attached to it

private subnets are attached to the private route table and nat gateway is attached for internet connection.

# security groups 
it creates three security groups  
for the sftp server security groups, inbound rule port 220 is opened

 for the webserver security group, inbound rule ports 80 and 443 are opened

 for the worker security groups,  inbound rule port 22 is opened

 for all the above security groups outbound rules, all ports are opened


# Sftp_server
I created the first sftp server in ec2 instance by adding a new user and group and added some configuration lines to /etc/ssh/sshd_config file 

The extra lines are 

Match group sftp_fosslinux 
ChrootDirectory /home 
X11Forwarding no 
AllowTcpForwarding no 
ForceCommand internal-sftp

the above line group sftp_fosslinux is a new group that was created.
from that ec2 instance, I have created ami and used that ami to create an sftp server

access sftp server from that user.

# web server

 creates an auto-scaling group with a launch template with pre-defined user data that as Nginx web server installed


# workers 
created with an auto-scaling group with image ubuntu:18.04 version

# sqs
it creates sqs queue with default values 

# sns
creates one SNS topic and one email subscription for that topic

# cloud watch 

creates a dashboard with CPU utilization metric