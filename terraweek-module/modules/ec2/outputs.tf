output "vpc-id" {
    value = aws_vpc.main.id
  
}

output "subnet-id" {
  value = aws_subnet.public1.id
}

output "instance-id" {
    value = aws_instance.my-instance[*].id
  
}

output "public-dns" {
    value = aws_instance.my-instance[*].public_dns
}

output "private-ip" {
    value = aws_instance.my-instance[*].private_ip
  
}

output "security-group-id" {
    value = aws_security_group.security_group.id
  
}