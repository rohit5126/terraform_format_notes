resource "aws_vpc" "main-vpc" {
    cidr_block = var.vpc-cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true # MANDATORY: Allows public IPs to get a DNS name
    enable_dns_support   = true 
    tags = var.tags

}

resource "aws_subnet" "main-subnet" {
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = var.subnet-cidr
    availability_zone = var.availabilty-zone
    map_public_ip_on_launch = true
    tags = var.tags
  
}

resource "aws_internet_gateway" "main-ig" {
    vpc_id = aws_vpc.main-vpc.id
    tags = var.tags
  
}

resource "aws_route_table" "main-table" {
    vpc_id = aws_vpc.main-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main-ig.id

    }
    tags = var.tags
}

resource "aws_route_table_association" "main-ass" {
    subnet_id = aws_subnet.main-subnet.id
    route_table_id = aws_route_table.main-table.id
  
}