output "vpc_id" {
  value = aws_vpc.ai_vpc.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet" {
    value = aws_subnet.private_subnet.*.id
}

output "sg-alb" {
    value = aws_security_group.ai-alb.id
}

output "sg-ecs-task" {
    value =  aws_security_group.ai-ecs_tasks.id
}
