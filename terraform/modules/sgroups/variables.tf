variable "vpc_id" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "http" { 
  type = number 
  default = 80
}

variable "https" { 
  type = number 
  default = 443
}

variable "app_port" { 
  type = number 
  default = 8080
}

variable "tcp" { 
  type = string 
  default = "tcp"
}

variable "allow" { 
  type = string 
  default = "0.0.0.0/0"
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "private_rt" {
  description = "ID of the private route table"
  type        = string
}