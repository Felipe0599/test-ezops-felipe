resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "test-felipe-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "test-felipe-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "test-felipe-Route-Table"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-test-felipe"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnetB-test-felipe"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "Private-test-felipe"
  }
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    rule_no = 100
    protocol    = "tcp"
    action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0 
    to_port     = 65535
  }

  ingress {
    rule_no = 101
    protocol    = "udp"
    action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 65535
  }

  ingress {
    rule_no = 102
    protocol    = "icmp"
    action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 255
  }
  egress {
    rule_no = 100
    protocol    = "-1"
    action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "AllowAllACL-test-felipe"
  }
}

resource "aws_network_acl_association" "public" {
  subnet_id     = aws_subnet.public.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "main" {
  subnet_id     = aws_subnet.private.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.main.id
}

resource "aws_instance" "kubernetes" {
  ami                    = "ami-005fc0f236362e99f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  key_name               = var.ec2_key_name

  user_data = "${file("${path.module}/../Kubernetes/setup_k0s.sh")}"
  tags = {
    Name = "test-felipe-kubernetes"
  }

  lifecycle {
    create_before_destroy = false
    prevent_destroy = true
  }
}

resource "aws_instance" "docker-compose" {
  ami                    = "ami-005fc0f236362e99f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  key_name               = var.ec2_key_name

  user_data = "${file("${path.module}/../Kubernetes/setup_compose.sh")}"

  tags = {
    Name = "test-felipe-docker-compose"
  }
}
