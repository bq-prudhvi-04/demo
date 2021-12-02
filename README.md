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

# Project Explanation 
This Project creates an AWS infrastructure with the help of Terraform tool.
The Terraform code uses module resources, The Terraform code workspace has mainly main.tf, variables.tf files and modules folder.
The main.tf file contains the AWS provider section, Backend configuration, and Modules section. The backend configuration has Terraform state file is stored in the S3 bucket.
This modules section targets different module resources which are mentioned in the main.tf file

Each Module resource is explained below 

# VPC Module
It creates a new VPC with three public, three private subnets, public route table, private route table, IGW, NAT Gateway, and Elastic IP.
CDIR blocks for VPC, public and private subnets are mentioned in variables.tf file

Public subnets are attached to the Default Public route table and the internet gateway is attached to it

Private subnets are attached to the Private route table and nat gateway is attached for internet connection.

NAT gateway is created in the public subnet and Elastic IP is attached to it.

# Security Groups  Module
It creates three security groups 
 
1) SFTP server security group, inbound rule port 220 is opened

 2) Web server security group, inbound rule ports 80 and 443 are opened

3) worker security group, inbound rule port 22 is opened

 for all the above security groups, outbound rule all ports are opened


# SFTP Server Module
Sftp server installation steps are

1) Creating an SFTP Group and User
```
sudo addgroup sftp_group
sudo useradd -m sftpuser -g sftp_group
```
2) Add password for SFTP user
```
sudo passwd sftpuser
```
3) grant the new SFTP user complete access to their new home directory
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
6) Restart the ssh server for applying changed configurations.
```
sudo service ssh restart
```

check for the SFTP server
```
sftp sftp@127.0.0.1
```
It will prompt for the password, enter a password for login into the SFTP server
Normally SSH connection by default uses port 22 but in this project, I have used port 220 for SFTP server connection.
If u want to change the port edit the sshd_config file, In the sshd_config file uncomment port 22 line and change to port 220, and restart the SSH daemon 
```
sudo service ssh restart
```
Now we can use the SFTP server at port 220
```
sftp -P 220 sftpuser@127.0.0.1
```
The above command is used to locally connect the SFTP server in our machine.
If U want to connect the SFTP server from another Machine use the following command
```
sftp -P 220 sftpuser@PUBLIC_IP
```
Here the PUBLIC_IP  is the SFPT server machine Public IP.

After all these above configurations are done, I have created an AMI from that instance and used that AMI  ID in the SFPT module to create an SFTP Server with the preloaded above configurations.

# Web Server Module
It creates an EC2 instance of Ubuntu:18.04 version on top of it, Nginx web server is installed.
In this module web server is created with an auto-scaling group with a launch template that has pre-defined user data as Nginx web server installation configuration.
Auto-scaling of web servers is done by targeting by CPUutilization metric.

# Job workers Module
In this module worker, the EC2 instance is created with an auto-scaling group with a launch template that has a pre-defined configuration.

Auto-scaling of worker M/c  is done by targeting by CPUutilization metric.

# SQS Module
It creates an SQS queue with all default configurations.

# SNS
Creates one SNS topic and one email subscription for that topic.

# CloudWatch 

Creates a dashboard with CPU utilization metric.

# How to run this Project 
Create a workspace or a folder and pull the above code to that folder.
First, configure the AWS credentials in your server, or U can directly pass credentials in the AWS provider section in main.tf file like shown below.
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
4) Terraform plan command creates an execution plan, it is like a dry run mode it shows which resources will be created.
```
terraform plan
```
5) This command will create the following resources, which are mentioned above.
```
terraform apply --auto-approve
```
 


