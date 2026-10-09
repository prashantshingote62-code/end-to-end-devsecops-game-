# Create the VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc-name
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.igw-name
  }
}

# Create the primary public subnet (replaces original data lookup)
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone1
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet-name
  }
}

# Create the Security Group
resource "aws_security_group" "sg-default" {
  vpc_id = aws_vpc.main.id
  name   = var.security-group-name
  description = "Default SG"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Existing resource definitions ---
# (Keeping your original Subnet2/RT/Association code below)

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet-name2
  }
}

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.rt-name2
  }
}

resource "aws_route_table_association" "rt-association2" {
  route_table_id = aws_route_table.rt2.id
  subnet_id      = aws_subnet.public-subnet2.id
}

resource "aws_route_table_association" "rt-association1" {
  route_table_id = aws_route_table.rt2.id
  subnet_id      = aws_subnet.subnet.id
}