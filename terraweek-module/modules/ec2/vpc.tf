resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true 
    enable_dns_support = true
    tags = local.common_tags

}

resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.main.id    #implicit dependency
    cidr_block = var.subnet-cidr
    map_public_ip_on_launch = true
    
    tags = local.common_tags
}

resource "aws_internet_gateway" "net" {
    vpc_id = aws_vpc.main.id
    tags = local.common_tags
  
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.net.id  #implicit dependency
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "table" {
    subnet_id = aws_subnet.public1.id
    route_table_id = aws_route_table.route.id
  
}

