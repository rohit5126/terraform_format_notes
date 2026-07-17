variable "region" {
  default = "eu-north-1"
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "subnet-cidr" {
  default = "192.168.0.0/24"
}

variable "instance_type" {
    default = "t3.small"

}

/*
variable "ami-id" {
  default = "ami-0aba19e56f3eaec05"
}
*/

variable "allowed-ports" {
  default = [22, 80, 8080]
}


variable "env" {
  type = string
}

variable "instance-count" {
  default = "1"
} 

variable "volume_size" {
  default = "12"
  
}