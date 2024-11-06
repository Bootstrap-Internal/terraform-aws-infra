variable "vpc_id" {
  description = "The id of the VPC"
  type        = string
}

variable "lb_listener" {
  description = "The load balancer listener"
}

variable "region" {
  description = "The region of the API gateway"
}
variable "stage_name" {
  description = "This is for defining the stage name for deployment" 
}

variable "api_port" {
  description = "This is for defining the port for api" 
}
# Commented on 04-11-2024
# variable "api_gateway" {
#   description = "Configuration for API Gateway, supporting multiple APIs with associated methods and integrations."
#   type = list(object({
#     name                    = string
#     api_gateway_methods     = object({
#       http_method           = string
#       authorization         = string
#     })
#     api_gateway_integrations = object({
#       http_method            = string
#       integration_http_method = string
#       type                   = string
#       #uri                    = string
#       connection_type        = string
#       connection_id          = string
#     })
#   }))
# }

variable "api_gateway_config" {
  description = "Configuration for multiple APIs, each with its methods and integrations"
  type = list(object({
    api = object({
      name       = string
      methods    = list(object({
        http_method   = string
        authorization = string
      }))
      integrations = list(object({
        http_method            = string
        integration_http_method = string
        type                   = string
        uri                    = string
        connection_type        = string
        connection_id          = string
      }))
      cors = optional(object({
        allow_origin  = string
        allow_headers = string
        allow_methods = string
      }))
    })
  }))
  default = []
}
