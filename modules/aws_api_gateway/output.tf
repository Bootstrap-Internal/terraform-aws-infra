# output "api_gateway_invoke_url" {
#   value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.api_deployment.stage_name}"
#   description = "List of IDs of private subnets."
# }
output "dynamic_rest_api" {
  description = "This the APIs created dynamically"
  value = aws_api_gateway_rest_api.api
}