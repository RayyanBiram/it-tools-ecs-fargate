variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
}

variable "availability_zone" {
  description = "Availability zones 2a and 2b"
  type        = list(string)
}

variable "public_subnet_cidr" {
  description = "Public CIDR for the subnets"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "CIDR for the subnets"
  type        = list(string)
}

variable "route_cidr" {
  description = "CIDR for the route table"
  type        = string
}