# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "MyAPI"
  description = "API Gateway for ECS Service"
}

# API Gateway VPC Link
resource "aws_api_gateway_vpc_link" "api_vpc_link" {
  name        = "api-vpc-link"
  target_arns = ["${var.lb_listener.arn}"]
}


module "root_api" {
  source           = "./root_api"
  rest_api_id      = aws_api_gateway_rest_api.api.id
  root_resource_id = aws_api_gateway_rest_api.api.root_resource_id
  lb_uri           = "http://${var.lb_listener.dns_name}:80"
  vpc_link_id      = aws_api_gateway_vpc_link.api_vpc_link.id
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "dev"
  depends_on = [
    module.root_api.integration
  ]
}
