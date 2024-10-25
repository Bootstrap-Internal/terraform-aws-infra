# Ensure this method is correctly defined and applied
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.root_resource_id
  http_method   = "GET"  # Make sure this matches the method used in your integration
  authorization = "NONE"
}

# API Gateway Integration using VPC Link
resource "aws_api_gateway_integration" "api_integration" {
  depends_on = [aws_api_gateway_method.api_method]
  rest_api_id   = var.rest_api_id
  resource_id   = var.root_resource_id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = var.lb_uri
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}
