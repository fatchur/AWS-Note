
variable "stage" {
  type=string
}
variable "name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string  
}

variable "subnets" {
  type = list(any)
}

variable "security_groups_ecs" {
  type = string
}

variable "security_groups_alb" {
  type = string
}

variable "frontliner_health_check_path" {
  type = string
}
variable "model_health_check_path" {
  type = string
}

variable "crowd_health_check_path" {
  type = string
}


variable "frontliner_taskdef" {}
variable "model_taskdef" {}
variable "crowd_taskdef" {}
