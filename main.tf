# 1 Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main_vpc"
  }
}

# 2 Create a subnet
resource "aws_subnet" "main_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "main_subnet"
  }
}

# 3 Create a security group
resource "aws_security_group" "web_sg" {
  name = "web_sg"
  description = "Web security group"  # allow http traffic
  vpc_id = aws_vpc.main_vpc.id
  # allow ssh traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow http traffic
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow all traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web_sg"
  }
}

# 4 Create a security group rule
resource "aws_security_group_rule" "web_sg_rule" {
  security_group_id = aws_security_group.web_sg.id
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# 5 Create the server instance EC2
resource "aws_instance" "web_server" {
  ami = "ami-0cae6d6fe6048ca2c"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.id]
  subnet_id = aws_subnet.main_subnet.id
  key_name = "aws-key"
  tags = {
    Name = "web_server"
  }
}
