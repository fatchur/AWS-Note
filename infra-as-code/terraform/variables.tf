
variable "stage" {
  default = "dev"
}

variable "account_id" {
  default = ""
}

variable "aws_region" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "vpc_cidr" {
  default = ""
}

variable "inet_gtw_id" {
  default = ""
}

variable "nat_gtw_id" {
  default = ""
}

variable "ecs_execution_role_arn" {
  default = "arn:aws:iam:::role/ai-ecs-task-role"
}




