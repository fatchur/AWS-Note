

###########################################
## FRONTLINER REPO 
###########################################
resource "aws_ecr_repository" "frontliner" {
  name                 = "${var.repoes.frontliner}"
  image_tag_mutability = "MUTABLE"

  #lifecycle {
  #      prevent_destroy = true
  #  }
}

resource "aws_ecr_lifecycle_policy" "frontliner" {
  repository = aws_ecr_repository.frontliner.name
 
  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 10 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 10
     }
   }]
  })
}


###########################################
## MODEL REPO 
###########################################
resource "aws_ecr_repository" "model" {
  name                 = "${var.repoes.model}"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "model" {
  repository = aws_ecr_repository.model.name
 
  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 10 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 10
     }
   }]
  })
}


###########################################
## CROWD REPO                             #
###########################################
resource "aws_ecr_repository" "crowd-algorithm" {
  name                 = "${var.repoes.crowd}"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "crowd-algorithm" {
  repository = aws_ecr_repository.crowd-algorithm.name
 
  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 10 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 10
     }
   }]
  })
}