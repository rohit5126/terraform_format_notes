variable "vpc-cidr" {
    default = "10.0.0.0/16"
  
}

variable "pub-cidr-1" {
    default = "10.0.1.0/24"
  
}

variable "pub-cidr-2" {
    default = "10.0.2.0/24"
  
}

variable "pvt-cidr-1" {
    default = "10.0.3.0/24"
  
}

variable "pvt-cidr-2" {
    default = "10.0.4.0/24"
  
}

variable "cluster-name" {
    default = "terraweek"
}

variable "cluster-version" {
    default = "1.34"
}

variable "tags" {
    default = {
        Name = "terra-week"
        Environment = "Dev"
    }
}

variable "instance_types" {
    default = "t3.micro"
}
