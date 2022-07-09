

resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "ai-vpc-link"
  #security_group_ids = [var.security_group_id]
  security_group_ids = []
  subnet_ids         = var.subnets_id

  tags = {
    Name = "ai-vpc-link"
  }
}


resource "aws_apigatewayv2_api" "main" {
  name          = "ai-http-api"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_stage" "main" {
  api_id = aws_apigatewayv2_api.main.id

  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.ai-gateway-log.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      #errorResponse           =  "$context.err_response"
      }
    )
  }
}

############################################
# gateway integration 
############################################
resource "aws_apigatewayv2_integration" "frontliner" {
  api_id           = aws_apigatewayv2_api.main.id
  #credentials_arn  = "arn:aws:iam::069232622018:role/ai-ecs-task-role"
  description      = "Example with a load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = var.frontliner_alb_listener_arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id

  
    depends_on      = [aws_apigatewayv2_vpc_link.main, 
                    aws_apigatewayv2_api.main]
}

resource "aws_apigatewayv2_integration" "model" {
  api_id           = aws_apigatewayv2_api.main.id
  description      = "Example with a load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = var.model_alb_listener_arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id

  
    depends_on      = [aws_apigatewayv2_vpc_link.main, 
                    aws_apigatewayv2_api.main]
}

resource "aws_apigatewayv2_integration" "crowd" {
  api_id           = aws_apigatewayv2_api.main.id
  description      = "Example with a load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = var.crowd_alb_listener_arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id

  
    depends_on      = [aws_apigatewayv2_vpc_link.main, 
                    aws_apigatewayv2_api.main]
}

############################################
# route for frontliner 
############################################
resource "aws_apigatewayv2_route" "frontliner" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.frontliner.id}"
  depends_on  = [aws_apigatewayv2_integration.frontliner]
}

resource "aws_apigatewayv2_route" "frontliner_healthcheck" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "GET /api/v1/health"
  target    = "integrations/${aws_apigatewayv2_integration.frontliner.id}"
  depends_on  = [aws_apigatewayv2_integration.frontliner]
}

############################################
# route for model
############################################
resource "aws_apigatewayv2_route" "model" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "ANY /api/v1/models/chicken_detection"
  target = "integrations/${aws_apigatewayv2_integration.model.id}"
  depends_on  = [aws_apigatewayv2_integration.model]
}

############################################
# route for crowd
############################################
resource "aws_apigatewayv2_route" "crowd" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "ANY /api/logic/v1/crowded"
  target = "integrations/${aws_apigatewayv2_integration.crowd.id}"
  depends_on  = [aws_apigatewayv2_integration.crowd]
}

resource "aws_cloudwatch_log_group" "ai-gateway-log" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.main.name}"
}

output "apigw_endpoint" {
  value = aws_apigatewayv2_api.main.api_endpoint
    description = "API Gateway Endpoint"
}

