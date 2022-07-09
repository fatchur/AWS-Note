
/*
module "repository" {
  source = "./repository"
  name   = "ai"
  repoes = local.repoes
}*/

#############################
## TEMP REMOVE this part (penghematan)
#############################


module "networking" {
  source             = "./networking"
  name               = "ai"
  vpc_cidr           = local.vpc_cidr
  max_subnets        = 4
  private_cidrs      = local.private_cidrs
  public_cidrs       = local.public_cidrs
  ecs_container_port = 8080
}


module "cluster" {
  source             = "./cluster"
  stage              = var.stage
  name               = "ai"
  aws_region         = var.aws_region
  frontliner_taskdef = local.frontliner_taskdef
  model_taskdef = local.model_taskdef
  crowd_taskdef = local.crowd_taskdef

  vpc_id              = module.networking.vpc_id
  subnets             = module.networking.private_subnet
  security_groups_ecs = module.networking.sg-ecs-task
  security_groups_alb = module.networking.sg-alb

  frontliner_health_check_path = "/api/v1/health"
  model_health_check_path = "/api/v1/health"
  crowd_health_check_path = "/api/v1/health"
}

/*
module "gateway" {
  source = "./gateway"
  name   = "ai"
  security_group_id =  module.networking.sg-alb
  subnets_id = module.networking.private_subnet
  frontliner_alb_listener_arn = module.cluster.frontliner_alb_listener_arn
  model_alb_listener_arn = module.cluster.model_alb_listener_arn
  crowd_alb_listener_arn = module.cluster.crowd_alb_listener_arn
}


module "queue" {
  source = "./queue"
}
*/