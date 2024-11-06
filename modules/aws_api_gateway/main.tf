# Local variable to hold flattened API methods and integrations for easy iteration
locals {
api_methods = flatten([
    for api_idx, api in var.api_gateway_config : [
      for method_idx, method in api.api.methods : {
        api_idx          = api_idx
        method_idx       = method_idx
        api_name         = api.api.name
        http_method      = method.http_method
        authorization    = method.authorization
        cors             = lookup(api.api, "cors", null)
      }
    ]
  ])

  api_integrations = flatten([
    for api_idx, api in var.api_gateway_config : [
      for integration in api.api.integrations : {
        api_idx                  = api_idx
        http_method              = integration.http_method
        integration_http_method  = integration.integration_http_method
        type                     = integration.type
        uri                      = integration.uri
        connection_type          = integration.connection_type
        connection_id            = integration.connection_id
      }
    ]
  ])
}

# API Gateway REST APIs
resource "aws_api_gateway_rest_api" "api" {
  for_each = { for api in var.api_gateway_config : api.api.name => api }

  name = each.value.api.name
}

# VPC Link 
resource "aws_api_gateway_vpc_link" "vpc_link" {
  for_each = { for integration in local.api_integrations : integration.connection_id => integration if integration.connection_type == "VPC_LINK" }

  name = "${each.value.api_idx}-vpc-link"
  target_arns = ["${var.lb_listener.arn}"]
}

# API Gateway Methods
resource "aws_api_gateway_method" "method" {
  for_each = {
    for method in local.api_methods :
    "${method.api_name}-${method.http_method}" => method
  }

  rest_api_id   = aws_api_gateway_rest_api.api[each.value.api_name].id
  resource_id   = aws_api_gateway_rest_api.api[each.value.api_name].root_resource_id
  http_method   = each.value.http_method
  authorization = each.value.authorization
}

# API Gateway Integrations
resource "aws_api_gateway_integration" "integration" {
  for_each = {
    for integration in local.api_integrations :
    "${integration.api_idx}-${integration.http_method}" => integration
  }

  rest_api_id             = aws_api_gateway_rest_api.api[var.api_gateway_config[each.value.api_idx].api.name].id
  resource_id             = aws_api_gateway_rest_api.api[var.api_gateway_config[each.value.api_idx].api.name].root_resource_id
  http_method             = each.value.http_method
  integration_http_method = each.value.integration_http_method
  type                    = each.value.type
  uri                     = "${each.value.uri}${var.lb_listener.dns_name}:${var.api_port}"
  connection_type         = each.value.connection_type
  connection_id           = each.value.connection_type == "VPC_LINK" ? aws_api_gateway_vpc_link.vpc_link[each.value.connection_id].id : null
}

resource "aws_api_gateway_deployment" "api_deployment" {
  for_each         = aws_api_gateway_rest_api.api
  rest_api_id = each.value.id
  stage_name  = var.stage_name
  depends_on = [
    aws_api_gateway_integration.integration
  ]
}

# API Gateway Method Responses for CORS
resource "aws_api_gateway_method_response" "cors_response" {
  for_each = {
    for method in local.api_methods :
    "${method.api_name}-${method.http_method}" => method if method.cors != null
  }

  rest_api_id = aws_api_gateway_rest_api.api[each.value.api_name].id
  resource_id = aws_api_gateway_rest_api.api[each.value.api_name].root_resource_id
  http_method = each.value.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = each.value.cors.allow_origin
    "method.response.header.Access-Control-Allow-Headers" = each.value.cors.allow_headers
    "method.response.header.Access-Control-Allow-Methods" = each.value.cors.allow_methods
  }
}

# API Gateway Integration Responses for CORS
resource "aws_api_gateway_integration_response" "cors_integration_response" {
  for_each = {
    for integration in local.api_integrations :
    "${integration.api_idx}-${integration.http_method}" => integration if var.api_gateway_config[integration.api_idx].api.cors != null
  }

  rest_api_id = aws_api_gateway_rest_api.api[var.api_gateway_config[each.value.api_idx].api.name].id
  resource_id = aws_api_gateway_rest_api.api[var.api_gateway_config[each.value.api_idx].api.name].root_resource_id
  http_method = each.value.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = var.api_gateway_config[each.value.api_idx].api.cors.allow_origin
    "method.response.header.Access-Control-Allow-Headers" = var.api_gateway_config[each.value.api_idx].api.cors.allow_headers
    "method.response.header.Access-Control-Allow-Methods" = var.api_gateway_config[each.value.api_idx].api.cors.allow_methods
  }
}


resource "aws_api_gateway_method" "options_method" {
  for_each = {
    for method in local.api_methods :
    "${method.api_name}-OPTIONS" => method
  }

  rest_api_id   = aws_api_gateway_rest_api.api[each.value.api_name].id
  resource_id   = aws_api_gateway_rest_api.api[each.value.api_name].root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Attach the OPTIONS Integration
resource "aws_api_gateway_integration" "options_integration" {
  for_each = aws_api_gateway_method.options_method

  rest_api_id             = each.value.rest_api_id
  resource_id             = each.value.resource_id
  http_method             = each.value.http_method
  type                    = "MOCK"
  integration_http_method = "OPTIONS"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}
