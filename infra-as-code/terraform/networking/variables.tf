

variable "name" {
  type = string
}

variable "vpc_cidr" {
    type =  string
}

variable "max_subnets" {
    type = number
}

variable "private_cidrs" {
  type = list(any)
}

variable "public_cidrs" {
  type = list(any)
}

variable "ecs_container_port" {
  type = number
}
