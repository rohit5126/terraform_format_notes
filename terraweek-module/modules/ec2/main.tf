
/*
resource "aws_default_vpc" "default" {

}
*/

resource "aws_key_pair" "keypair" {
    key_name = "terra-key"
    public_key = file("${path.module}/../terra-key.pub")
  
}

resource "aws_security_group" "security_group" {
    # depends_on = [ aws_vpc.main, aws_subnet.public1 ]
    name = local.project-name
    vpc_id = aws_vpc.main.id

    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
        from_port = var.allowed-ports[0]
        to_port = var.allowed-ports[0]

    }  

    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
        from_port = var.allowed-ports[1]
        to_port = var.allowed-ports[1]

    } 

    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
        from_port = var.allowed-ports[2]
        to_port = var.allowed-ports[2]

    } 

    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "-1"
        from_port = 0
        to_port = 0
        
    }

}

resource "aws_instance" "my-instance" {
    # depends_on = [ aws_vpc.main, aws_subnet.public1, aws_route_table.route, aws_route_table_association.table]
    vpc_security_group_ids = [aws_security_group.security_group.id]
    count = var.instance-count
    subnet_id = aws_subnet.public1.id
    key_name = aws_key_pair.keypair.key_name
    lifecycle {
      create_before_destroy = true
    }
    instance_type = var.env == "dev" ? var.instance_type : "c7i-flex.large"
    ami = data.aws_ami.ubuntu.id
    
    associate_public_ip_address = true
    root_block_device {
      volume_size = var.env == "dev" ? var.volume_size : "25"
      volume_type = "gp3"
      
    }
    tags = local.common_tags

}


