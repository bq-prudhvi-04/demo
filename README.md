# Prerequisites
Knowledge in AWS cloud and Terraform modules 
Terraform version used is v1.0.11
For running code, the platform used is Ubuntu:18.04

 # Installation instructions for terraform
Download terraform from the official site based on your platform.
 In this project, I have used the ubuntu:18.04 version platform. 

In Ubuntu, installation steps follow.
```
 wget https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
 unzip terraform_1.0.11_linux_amd64.zip
 mv terraform /usr/bin/
# check for terraform version   
 terraform version
```

# How to run the Project 
Create a workspace or a folder and pull the above code to that folder.
First, configure the AWS credentials in your server, or U can directly pass credentials in the AWS provider section in main.tf file 
```
provider "aws" {
  region = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}
```

Run the following terraform lifecycle commands

1) Terraform init command will download the provider plugins of the latest version.
```
terraform init
```
2) Terraform fmt command will Terraform configuration files to a canonical format and style
```
terraform fmt
```
3) Terraform validate command will validate the configuration files in a directory and check for any errors in code.
```
terraform validate
```
4) Terraform plan command creates an execution plan, it is like a dry run mode it shows which resources will be created 
```
terraform plan
```
5) This command will create the following resources which are mentioned below.
```
terraform apply --auto-approve
```
 
# VPC 
creates a new VPC with three public and private subnets

public subnets are attached to the default route table and the internet gateway is attached to it

Private subnets are attached to the Private route table and nat gateway is attached for internet connection.

# Security Groups 
it creates three security groups  
for the sftp server security groups, inbound rule port 220 is opened

 for the webserver security group, inbound rule ports 80 and 443 are opened

 for the worker security groups, inbound rule port 22 is opened

 for all the above security groups outbound rules, all ports are opened


# SFTP Server
Sftp server installation steps are
1)Creating an SFTP Group and User
```
sudo addgroup sftp_group
sudo useradd -m sftpuser -g sftp_group
```
2) Add password for SFTP user
```
sudo passwd sftpuser
```
3)grant the new SFTP user complete access to their new home directory
```
sudo chmod 700 /home/sftpuser/
```
4) Install SSH Daemon
```
sudo apt install ssh
```
5) Configure SSH Daemon
Edit the sshd_config file 
```
sudo vi /etc/ssh/sshd_config
```
Make PasswordAuthentication yes line like below.
```
 PasswordAuthentication yes
```
Now scroll down to the end of the configuration file and add the next few lines.
```
Match group sftp_group
ChrootDirectory /home 
X11Forwarding no 
AllowTcpForwarding no 
ForceCommand internal-sftp
```


 I have created an AMI from that instance and used that AMI to create an SFTP Server

Access sftp server from the above user created.

# web server

Creates an auto-scaling group with a launch template with pre-defined user data that as Nginx web server installed


# Job workers 
Created by an auto-scaling group with image ubuntu:18.04 version

# SQS
It creates an SQS queue with default values 

# SNS
Creates one SNS topic and one email subscription for that topic

# CloudWatch 

Creates a dashboard with CPU utilization metric

