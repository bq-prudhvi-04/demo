data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}


resource "aws_efs_file_system" "demo" {
  creation_token = "my-product"

  #vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "MyProduct"
  }
}
