output "vpc-id" {
    value = aws_vpc.main-vpc.id
}

output "subnet-id" {
    value = aws_subnet.main-subnet.id
  
}