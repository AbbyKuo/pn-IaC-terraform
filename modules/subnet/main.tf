# Public subnets 
resource "aws_subnet" "pn-server-public-subnet" {
  count             = length(var.public_subnet_cidr_blocks)      # 2
  vpc_id            = var.vpc_id                                 # vpc-05e862ea4b3e780a2
  cidr_block        = var.public_subnet_cidr_blocks[count.index] # 10.0.1.0/24
  availability_zone = var.availability_zone[count.index]         # ap-southeast-2a
  tags = {
    "Name" = "${var.env_prefix}-pn-server-public-subnet-${count.index + 1}" # dev-pn-server-public-subnet-1
  }
}

# Private subnets 
resource "aws_subnet" "pn-server-private-subnet" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    "Name" = "${var.env_prefix}-pn-server-private-subnet-${count.index + 1}"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "pn-server-igw" {
  vpc_id = var.vpc_id
  tags = {
    "Name" = "${var.env_prefix}-pn-server-igw"
  }
}

# Public route table 
resource "aws_route_table" "pn-server-public-rtb" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pn-server-igw.id
  }
  tags = {
    "Name" = "${var.env_prefix}-pn-server-public-rtb"
  }
}

# Associate public route table
resource "aws_route_table_association" "a-public-rtb" {
  count          = length(var.public_subnet_cidr_blocks)                         # 2
  subnet_id      = element(aws_subnet.pn-server-public-subnet.*.id, count.index) # subnet-09aecf69f49eceeb9
  route_table_id = aws_route_table.pn-server-public-rtb.id                       # rtb-0275f7699dffecf70
}


# eip for nat gateway
resource "aws_eip" "pn-server-ngw-eip" {
  vpc = true

  tags = {
    "Name" = "${var.env_prefix}-pn-server-ngw-eip"
  }
}

#  Nat gateway
resource "aws_nat_gateway" "pn-server-ngw" {
  allocation_id = aws_eip.pn-server-ngw-eip.allocation_id
  subnet_id     = aws_subnet.pn-server-public-subnet[0].id
  tags = {
    "Name" = "${var.env_prefix}-pn-server-ngw"
  }

  depends_on = [aws_internet_gateway.pn-server-igw]
}

#  Private route table
resource "aws_route_table" "pn-server-private-rtb" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.pn-server-ngw.id
  }

  tags = {
    "Name" = "${var.env_prefix}-pn-server-private-rtb"
  }
}

# Associate private route table
resource "aws_route_table_association" "a-private-rtb-subnet" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.pn-server-private-subnet.*.id, count.index)
  route_table_id = aws_route_table.pn-server-private-rtb.id
}