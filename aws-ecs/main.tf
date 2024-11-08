# 1. create data block for  (vpc_id)
# 2. create data block for (security group ids) or get security group ids from YAML

locals {
  ecs_configs = yamldecode(file("${path.module}/config/dev-config.yaml"))
  #ecs_configs = yamldecode(file("${path.module}/config/${env_name}"))  
  security_groups_data = yamldecode(file("${path.module}/config/data-security-sg.yaml"))
  raw_api_gateway_config =  yamldecode(file("${path.module}/config/api-gateway-config.yaml"))
  
}

locals {
  api_gateway_config = [
    for api in local.raw_api_gateway_config.api_gateway : {
      api = {
        name       = api.api.name
        methods    = [
          for method in api.api.methods : {
            http_method   = method.http_method
            authorization = method.authorization
          }
        ]
        integrations = [
          for integration in api.api.integrations : {
            http_method            = integration.http_method
            integration_http_method = integration.integration_http_method
            type                   = integration.type
            uri                    = integration.uri
            connection_type        = integration.connection_type
            connection_id          = lookup(integration, "connection_id", null)
          }
        ]
      }
    }
  ]
}

data "aws_vpc" "vpc" {
  id = local.ecs_configs.ecs.vpc_id
}
resource "aws_ecs_cluster" "cluster" {
  name = local.ecs_configs.ecs.cluster_name
}

resource "aws_sns_topic" "alarm_topic" {
  name = "${var.project_name}-alarm-topic"
}

# ECS Service
module "app1" {
  source                      = "../Products/ecs_app"
  ecs_configs                 = local.ecs_configs
  ecs_task_execution_role_arn = var.ecs_iam_arn
  rnt_aws_ecs_cluster         = aws_ecs_cluster.cluster
  my_api_gateway_config       = local.api_gateway_config
  my_security_groups          = local.security_groups_data["security_groups"]
}


