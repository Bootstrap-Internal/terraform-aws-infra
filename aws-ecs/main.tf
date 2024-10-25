# 1. create data block for  (vpc_id)
# 2. create data block for (security group ids) or get security group ids from YAML

locals {
  ecs_configs = yamldecode(file("${path.module}/config/dev-config.yaml"))
  #ecs_configs = yamldecode(file("${path.module}/config/${env_name}"))  
  security_groups_data = yamldecode(file("${path.module}/config/data-security-sg.yaml"))
}

# locals {
# networking_map = {"vpc_id" = data.aws_vpc.vpc_id "subnet_id" = data.aws_vpc.subnet_ids}
# ecs_configs = merge(yamldecode(file("").ecs), neworking_map)
# }
data "aws_vpc" "vpc" {
  id = local.ecs_configs.ecs.vpc_id
}
resource "aws_ecs_cluster" "cluster" {
  name = local.ecs_configs.ecs.cluster_name
}
module "security_groups" {
  source          = "../modules/aws_security_groups"
  security_groups = local.security_groups_data["security_groups"]
}
# Network Load Balancer for API Gateway VPC Link
resource "aws_lb" "api_nlb" {
  name                       = local.ecs_configs.ecs.api_nlb_name
  internal                   = true
  load_balancer_type         = local.ecs_configs.ecs.nlb_type
  subnets                    = local.ecs_configs.ecs.subnet_ids
  security_groups            = [module.security_groups.elb_security_group_id]
  enable_deletion_protection = false
}

module "api_gateway" {
  source      = "../modules/aws_api_gateway"
  vpc_id      = data.aws_vpc.vpc.id
  lb_listener = aws_lb.api_nlb
  region      = local.ecs_configs.ecs.region
}

resource "aws_sns_topic" "alarm_topic" {
  name = "${var.project_name}-alarm-topic"
}

# ECS Service
module "app1" {
  source                      = "../Products/ecs_app"
  ecs_configs                 = local.ecs_configs
  lb_listener                 = aws_lb.api_nlb
  rnt_app_security_group_id   = [module.security_groups.vpc_endpoint_security_group_id, module.security_groups.app_security_group_id]
  ecs_task_execution_role_arn = var.ecs_iam_arn
  rnt_aws_ecs_cluster         = aws_ecs_cluster.cluster
}


