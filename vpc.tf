resource "aws_vpc" "app" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "app"
  }
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.app.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id                  = aws_vpc.app.id
  for_each                = var.subnet_definition
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = split("-", each.value.name)[0] == "public" ? true : false
  tags = {
    Name = each.value.name
  }

}

resource "aws_default_route_table" "private_route" {
  default_route_table_id = aws_vpc.app.default_route_table_id

  tags = {
    "Name" = "private"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
  tags = {
    "Name" = "public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.subnet_definition

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = split("-", each.value.name)[0] == "public" ? aws_route_table.public_route.id : aws_default_route_table.private_route.id
}

resource "aws_security_group" "allow_http_https" {
  name        = "allow_http_https"
  description = "Allow http and https inbound traffic"
  vpc_id      = aws_vpc.app.id

  ingress {
    description      = "http from Internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "https from Internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http_https"
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.app.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "internal_allow"
  }
}

resource "aws_network_acl" "public_web" {
  vpc_id = aws_vpc.app.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 201
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 202
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = "public_web"
  }
}

resource "aws_network_acl_association" "allow_http_ingress_egress" {
  for_each = var.subnet_definition

  subnet_id      = aws_subnet.subnets[each.key].id
  network_acl_id = split("-", each.value.name)[0] == "public" ? aws_network_acl.public_web.id : aws_default_network_acl.default.id
}

# output "subnet" {
#   for_each = var.subnet_definition

#   value = aws_subnet.subnets[each.key].name
# }

output "security_group" {
  value = aws_security_group.allow_http_https.id
}
