

resource "aws_ecs_cluster" "main" {
  name = "${var.name}-${var.stage}-cluster"
}


########################################
# create ecs task definition FRONTLINER
########################################
resource "aws_ecs_task_definition" "frontliner" {
  family                   = var.frontliner_taskdef.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::069232622018:role/ai-ecs-task-role"
  task_role_arn            = "arn:aws:iam::069232622018:role/ai-ecs-task-role"

  container_definitions = jsonencode([{
    name      = var.frontliner_taskdef.name
    image     = "${var.frontliner_taskdef.image}:latest"
    essential = true
    #environment = var.frontliner_taskdef.vars
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.frontliner_taskdef.port
      hostPort      = var.frontliner_taskdef.port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group = "true"
        awslogs-group         = var.frontliner_taskdef.cloudwatch_group
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}


########################################
# create ecs task definition model
########################################
resource "aws_ecs_task_definition" "model" {
  family                   = var.model_taskdef.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "arn:aws:iam::069232622018:role/ai-ecs-task-role"
  task_role_arn            = "arn:aws:iam::069232622018:role/ai-ecs-task-role"

  container_definitions = jsonencode([{
    name      = var.model_taskdef.name
    image     = "${var.model_taskdef.image}:latest"
    essential = true
    #environment = var.frontliner_taskdef.vars
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.model_taskdef.port
      hostPort      = var.model_taskdef.port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group = "true"
        awslogs-group         = var.model_taskdef.cloudwatch_group
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

########################################
# create ecs task definition crowd
########################################
resource "aws_ecs_task_definition" "crowd" {
  family                   = var.crowd_taskdef.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "arn:aws:iam::069232622018:role/ai-ecs-task-role"
  task_role_arn            = "arn:aws:iam::069232622018:role/ai-ecs-task-role"

  container_definitions = jsonencode([{
    name      = var.crowd_taskdef.name
    image     = "${var.crowd_taskdef.image}:latest"
    essential = true
    #environment = var.frontliner_taskdef.vars
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.crowd_taskdef.port
      hostPort      = var.crowd_taskdef.port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group = "true"
        awslogs-group         = var.crowd_taskdef.cloudwatch_group
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}


##############################################
# AWS Load Balancer
# frontliner
##############################################
resource "aws_lb" "frontliner" {
  name               = "${var.name}-alb-${var.stage}-frontliner"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.security_groups_alb]
  subnets            = var.subnets
 
  enable_deletion_protection = false
}
 
resource "aws_alb_target_group" "frontliner" {
  name        = "${var.name}-alb-tg-${var.stage}-frontliner"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "10"
   path                = var.frontliner_health_check_path
   unhealthy_threshold = "2"
   port = var.frontliner_taskdef.port
  }
}

resource "aws_alb_listener" "frontliner" {
  load_balancer_arn = aws_lb.frontliner.id
  port              = 80
  protocol          = "HTTP"
 
  default_action {
    target_group_arn = aws_alb_target_group.frontliner.id
    type             = "forward"

  }
}


##############################################
# AWS Load Balancer
# Model
##############################################
resource "aws_lb" "model" {
  name               = "${var.name}-alb-${var.stage}-model"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.security_groups_alb]
  subnets            = var.subnets
 
  enable_deletion_protection = false
}
 
resource "aws_alb_target_group" "model" {
  name        = "${var.name}-alb-tg-${var.stage}-model"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "2"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "10"
   path                = var.model_health_check_path
   unhealthy_threshold = "3"
   port = var.model_taskdef.port
  }
}

resource "aws_alb_listener" "model" {
  load_balancer_arn = aws_lb.model.id
  port              = 80
  protocol          = "HTTP"
 
  default_action {
    target_group_arn = aws_alb_target_group.model.id
    type             = "forward"

  }

  depends_on = [
    aws_lb.model, aws_alb_target_group.model
  ]
}

##############################################
# AWS Load Balancer
# Crowd
##############################################
resource "aws_lb" "crowd" {
  name               = "${var.name}-alb-${var.stage}-crowd"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.security_groups_alb]
  subnets            = var.subnets
 
  enable_deletion_protection = false
}
 
resource "aws_alb_target_group" "crowd" {
  name        = "${var.name}-alb-tg-${var.stage}-crowd"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "2"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "10"
   path                = var.crowd_health_check_path
   unhealthy_threshold = "3"
   port = var.crowd_taskdef.port
  }
}

resource "aws_alb_listener" "crowd" {
  load_balancer_arn = aws_lb.crowd.arn
  port              = 80
  protocol          = "HTTP"
 
  default_action {
    target_group_arn = aws_alb_target_group.crowd.id
    type             = "forward"

  }

  depends_on = [
    aws_lb.crowd, aws_alb_target_group.crowd
  ]
}


##############################################
# ECS SERVICE, frontliner
##############################################
resource "aws_ecs_service" "frontliner" {
 name                               = "${var.name}-service-frontliner"
 cluster                            = aws_ecs_cluster.main.id
 task_definition                    = aws_ecs_task_definition.frontliner.arn
 desired_count                      = 1
 deployment_minimum_healthy_percent = 50
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"
 
 network_configuration {
   security_groups  = [var.security_groups_ecs]
   subnets          = var.subnets
   assign_public_ip = false
 }
 
 load_balancer {
   target_group_arn = aws_alb_target_group.frontliner.arn
   container_name   = var.frontliner_taskdef.name
   container_port   = var.frontliner_taskdef.port
 }
 
 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}


##############################################
# ECS SERVICE, model
##############################################
resource "aws_ecs_service" "model" {
 name                               = "${var.name}-service-model"
 cluster                            = aws_ecs_cluster.main.id
 task_definition                    = aws_ecs_task_definition.model.arn
 desired_count                      = 1
 deployment_minimum_healthy_percent = 50
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"
 
 network_configuration {
   security_groups  = [var.security_groups_ecs]
   subnets          = var.subnets
   assign_public_ip = false
 }
 
 load_balancer {
   target_group_arn = aws_alb_target_group.model.arn
   container_name   = var.model_taskdef.name
   container_port   = var.model_taskdef.port
 }
 
 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}


##############################################
# ECS SERVICE, crowd
##############################################
resource "aws_ecs_service" "crowd" {
 name                               = "${var.name}-service-crowd"
 cluster                            = aws_ecs_cluster.main.id
 task_definition                    = aws_ecs_task_definition.crowd.arn
 desired_count                      = 1
 deployment_minimum_healthy_percent = 50
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"
 
 network_configuration {
   security_groups  = [var.security_groups_ecs]
   subnets          = var.subnets
   assign_public_ip = false
 }
 
 load_balancer {
   target_group_arn = aws_alb_target_group.crowd.arn
   container_name   = var.crowd_taskdef.name
   container_port   = var.crowd_taskdef.port
 }
 
 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}