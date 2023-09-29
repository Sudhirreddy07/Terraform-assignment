variable "tags" {
 default = {
    purpose = "Assigment"
  }
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "pub_subnet_cidr" {
  default = "10.0.0.0/25"
}

variable "pri_subnet_cidr" {
  default = "10.0.1.0/25"
}

variable "azs" {
  default = "us-east-1a"
}