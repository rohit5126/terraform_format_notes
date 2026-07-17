output "public-ip" {
    value = aws_instance.my-instance[*].public_ip
}

output "public-dns" {
    value = aws_instance.my-instance[*].public_dns
  
}

output "private-ip" {
    value = aws_instance.my-instance[*].private_ip
  
}