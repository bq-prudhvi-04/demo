provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

terraform {
  backend "s3" {
    profile = "default"
    bucket  = "terraformstatecode3"
    key     = "task/terraform.tfstate"
    region  = "us-east-1"

  }
}

module "vpc" {
  source = "./modules/vpc"

}

module "ec2_sftp" {
  source          = "./modules/ec2_sftp"
  security_groups = module.SG.security_groups_sftp
  public_subnet   = element(module.vpc.public_subnet, 1 )

}

module "ec2_webserver" {
  source          = "./modules/ec2_webserver"
  security_groups = module.SG.security_groups_webserver
  public_subnet   = element(module.vpc.public_subnet, 1 )



}

module "SG" {
  source = "./modules/SG"
  vpc_id = module.vpc.vpc_id
}

module "auto_scale" {

  source          = "./modules/auto_sacle"
  security_groups = module.SG.security_groups_webserver
  public_subnet = element(module.vpc.public_subnet, 0)

}

module "sqs" {
  source = "./modules/sqs"

}

module "sns" {
  source = "./modules/sns"
}

module "efs" {

  source = "./modules/efs"
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  
}

module "worker" {
  source = "./modules/jobworkers"
  security_groups = module.SG.security_groups_worker
  private_subnet = element(module.vpc.private_subnet, 0)

  
}