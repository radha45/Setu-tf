locals {
  az = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

resource "aws_vpc" "vpc" {
  cidr_block         = var.vpc_cidr
  enable_dns_support = true
  tags = {
    Name      = "${var.project}-vpc"
    managedBy = "terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "${var.project}-igw"
    managedBy = "terraform"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name      = "pub-${var.project}-rt"
    type      = "public"
    managedBy = "terraform"
  }
}

resource "aws_eip" "Nat-Gateway-EIP" {
  depends_on = [
    aws_route_table_association.public_as
  ]
  vpc = true
}

resource "aws_nat_gateway" "NAT_GATEWAY" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP,
    aws_subnet.public_subnet
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.Nat-Gateway-EIP.id

  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.public_subnet[0].id
 tags = {
    Name      = "${var.project}-nat"
    project   = var.project
    managedBy = "terraform"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_GATEWAY.id
  }
  tags = {
    Name      = "pvt-${var.project}-rt"
    type      = "private"
    managedBy = "terraform"
  }
}

resource "aws_route_table_association" "public_as" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_as" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnet_cidrs)
  availability_zone       = local.az[count.index]
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name      = "pub-${var.project}-subnet${count.index}"
    type      = "public"
    managedBy = "terraform"
  }
}


resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnet_cidrs)
  availability_zone       = local.az[count.index]
  cidr_block              = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name      = "pvt-${var.project}-subnet${count.index}"
    type      = "private"
    managedBy = "terraform"
  }
}