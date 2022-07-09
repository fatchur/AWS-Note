

variable "name" {
    type  = string
}


variable "security_group_id" { }
variable "subnets_id" {
    type = list(any)
}
variable "frontliner_alb_listener_arn" {}
variable "model_alb_listener_arn" {}
variable "crowd_alb_listener_arn" {}