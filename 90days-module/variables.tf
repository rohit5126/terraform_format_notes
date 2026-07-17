variable "vpc-cidr" {
    default = "10.0.0.0/16"
}

variable "subnet-cidr" {
    default = "10.0.1.0/24"
  
}

variable "availabilty-zone" {
    default = "eu-north-1a"
  
}

variable "count-in" {
    default = "2"
  
}


variable "sg-name" {
    default = "terra-week-dev"

}

variable "ingress_ports" {
    default = [22, 80, 443]
  
}

variable "tags" {
    default = {
        Name = "terra-week-dev"
        Environment = "Dev"
    }
  
}

variable "ami_id" {
    default = "ami-0aba19e56f3eaec05"
  
}

variable "instance_type" {
    default = "t3.micro"
  
}

