
data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "ai_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ai-vpc"
  }

  lifecycle {
    create_before_destroy = true
  }
}
 

resource "aws_internet_gateway" "ai-inet-gtw" {
  vpc_id = aws_vpc.ai_vpc.id

  tags = {
    Name = "ai-inet-gtw"
  }
}


######################################
## subnet 
######################################
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.ai_vpc.id
  count             = length(var.private_cidrs)
  cidr_block        = element(var.private_cidrs, count.index)
  availability_zone = element(random_shuffle.az_list.result, count.index)

  tags = {
    Name = "ai-private-${count.index + 1}"
  }
  
}
 
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.ai_vpc.id
  count                   = length(var.public_cidrs)
  cidr_block              = element(var.public_cidrs, count.index)
  availability_zone       = element(random_shuffle.az_list.result, count.index)
  map_public_ip_on_launch = true

    tags = {
    Name = "ai-public-${count.index + 1}"
  }
}

#######################################
# PUBLIC SUBNET 
# Routing table
#######################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ai_vpc.id

  tags = {
    Name = "ai-public-rt"
  }
}
 
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ai-inet-gtw.id
}
 
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(var.public_cidrs)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}


#######################################
# PRIVATE SUBNET 
# Routing table
#######################################

resource "aws_eip" "nat_eip" {
  count = length(var.private_cidrs)
  vpc = true
}

resource "aws_nat_gateway" "nat_gtw" {
  count         = length(var.private_cidrs)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on    = [aws_internet_gateway.ai-inet-gtw]
}
 
resource "aws_route_table" "private_rt" {
  count  = length(var.private_cidrs)
  vpc_id = aws_vpc.ai_vpc.id

    tags = {
    Name = "ai-private-rt"
  }
}
 
resource "aws_route" "private_route" {
  count                  = length(compact(var.private_cidrs))
  route_table_id         = element(aws_route_table.private_rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat_gtw.*.id, count.index)
}
 
resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(var.private_cidrs)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}


#######################################
# SECURITY GROUP 
#######################################
resource "aws_security_group" "ai-alb" {
  name   = "${var.name}-sg-alb"
  vpc_id = aws_vpc.ai_vpc.id
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = 443
   to_port          = 443
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
   protocol         = "tcp"
   from_port        = 22
   to_port          = 22
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

   tags = {
    Name = "${var.name}-sg-alb"
  }
}

resource "aws_security_group" "ai-ecs_tasks" {
  name   = "${var.name}-sg-ecs-task"
  vpc_id = aws_vpc.ai_vpc.id
 
  ingress {
   protocol         = "tcp"
   from_port        = var.ecs_container_port
   to_port          = var.ecs_container_port
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name}-sg-ecs-task"
  }
}