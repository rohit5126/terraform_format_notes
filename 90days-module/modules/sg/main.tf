resource "aws_security_group" "my-sg" {
    name = var.sg-name
    vpc_id = var.vpc-id
    ingress {
        from_port = var.ingress_ports[0]
        to_port = var.ingress_ports[0]
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        from_port = var.ingress_ports[1]
        to_port = var.ingress_ports[1]
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        from_port = var.ingress_ports[2]
        to_port = var.ingress_ports[2]
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }


  
}