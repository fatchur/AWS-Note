

output "frontliner_alb_listener_arn" {
  value = aws_alb_listener.frontliner.arn
}

output "model_alb_listener_arn" {
  value = aws_alb_listener.model.arn
}

output "crowd_alb_listener_arn" {
  value = aws_alb_listener.crowd.arn
}