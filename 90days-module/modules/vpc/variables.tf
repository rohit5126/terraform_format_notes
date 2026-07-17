variable "vpc-cidr" {
    type = string
}

variable "subnet-cidr" {
    type = string
  
}

variable "availabilty-zone" {
    type = string
  
}

variable "tags" {
    description = "tags will be passed from root module"

}