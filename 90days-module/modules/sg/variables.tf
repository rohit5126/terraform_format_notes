
variable "vpc-id" {
    type = string

}

variable "sg-name" {
    type = string

}

variable "ingress_ports" {
    type = list(number)

  
}

variable "tags" {
    description = "value will be passed from root module"
  
}
