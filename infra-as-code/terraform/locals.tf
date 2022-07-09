locals {
  vpc_cidr = "10.123.0.0/16"
}


locals {
  private_cidrs = [for i in range(1, 5, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

locals {
  public_cidrs = [for i in range(2, 6, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

locals {
  repoes = {
    frontliner = "ai-frontliner"
    model = "ai-chicken-detection-model"
    crowd = "ai-crowd_algorithm"
  }
}

locals {
  frontliner_taskdef = {
    name             = local.repoes.frontliner
    image            = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${local.repoes.frontliner}"
    vars             = {}
    port             = 8080
    cloudwatch_group = "ai-frontliner"
  }
}

locals {
  model_taskdef = {
    name             = local.repoes.model
    image            = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${local.repoes.model}"
    vars             = {}
    port             = 8080
    cloudwatch_group = "ai-model"
  }
}

locals {
  crowd_taskdef = {
    name             = local.repoes.crowd
    image            = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${local.repoes.crowd}"
    vars             = {}
    port             = 8080
    cloudwatch_group = "ai-crowd_algorithm"
  }
}

