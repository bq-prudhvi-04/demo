
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-test-vpc"
  }
}

# Creating Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-test-igw"
  }
}


# Public Route Table

resource "aws_default_route_table" "public_route" {
   default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "my-test-public-route"
  }
}

# Private Route Table

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    nat_gateway_id = aws_nat_gateway.my-test-nat-gateway.id
    cidr_block     = "0.0.0.0/0"
  }

  tags = {
    Name = "my-test-private-route"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = 3
  cidr_block              = var.public_cidrs[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = var.aws_az[count.index]

  tags = {
    Name = "my-test-public-subnet_${count.index + 1}"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = 3
  cidr_block        = var.private_cidrs[count.index]
  vpc_id            = aws_vpc.main.id
  availability_zone = var.aws_az[count.index]

  tags = {
    Name = "my-test-private-subnet_${count.index + 1}"
  }
}

# elastic ip for nat gateway
resource "aws_eip" "my-test-eip" {
  vpc = true
}
# creating NAT gateway
resource "aws_nat_gateway" "my-test-nat-gateway" {
  allocation_id = aws_eip.my-test-eip.id
  subnet_id     = aws_subnet.public_subnet.0.id
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = 3
  route_table_id = aws_default_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = 3
  route_table_id = aws_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
}