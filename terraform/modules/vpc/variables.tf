
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}


variable "private_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "azs" {
  description = "Availability zones for the public subnets."
  type        = list(string)
}
