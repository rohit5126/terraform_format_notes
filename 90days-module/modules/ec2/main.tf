resource "aws_instance" "my-instance"  {
    vpc_security_group_ids = [var.sg-group-id]
    count = var.count-in
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    key_name = "k8s-key"
    root_block_device {
      volume_size = "12"
      volume_type = "gp3"
      
    }
    tags = var.tags
    
  
}