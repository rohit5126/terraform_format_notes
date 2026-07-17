module "vpc" {
    source = "./modules/vpc"
    vpc-cidr = var.vpc-cidr
    subnet-cidr = var.subnet-cidr
    tags = var.tags
    availabilty-zone = var.availabilty-zone
}

module "sg" {
    source = "./modules/sg"
    sg-name = var.sg-name
    vpc-id = module.vpc.vpc-id
    ingress_ports = var.ingress_ports
    tags = var.tags
  
}

module "ec2" {
    source = "./modules/ec2"
    ami_id = var.ami_id
    count-in = var.count-in
    instance_type = var.instance_type
    subnet_id = module.vpc.subnet-id
    sg-group-id = module.sg.sg-id
    tags = var.tags
}