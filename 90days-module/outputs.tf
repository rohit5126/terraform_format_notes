output "public-ip" {
    value = module.ec2.public-ip
  
}

output "private-ip" {
    value = module.ec2.private-ip

  
}

output "public-dns" {
    value = module.ec2.public-dns
  
}