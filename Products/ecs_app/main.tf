data "aws_ecr_repository" "rnt_ecr_repo" {
  name = var.ecs_configs.ecs.ecr_repo_name
}

module "log_group" {
  source            = "../../modules/aws_ecs/log_group"
  app_name          = var.ecs_configs.ecs.app_name
  retention_in_days = var.ecs_configs.ecs.log_retention_in_days        
}

module "task_definition" {
  source                      = "../../modules/aws_ecs/task_definition"
  app_name                    = var.ecs_configs.ecs.app_name
  task_cpu                    = var.ecs_configs.ecs.task_definition.task_cpu
  task_memory                 = var.ecs_configs.ecs.task_definition.task_memory
  container_port              = var.ecs_configs.ecs.container_port
  host_port                   = var.ecs_configs.ecs.task_definition.host_port
  vpc_id                      = var.ecs_configs.ecs.vpc_id
  ecr_repository_url          = data.aws_ecr_repository.rnt_ecr_repo.repository_url
  ecs_task_execution_role_arn = var.ecs_task_execution_role_arn
  log_group_name              = module.log_group.log_group_name
  log_group_region            = var.ecs_configs.ecs.task_definition.log_group_region
  image_tag                   = var.ecs_configs.ecs.image_tag
}

# Target Group for the Network Load Balancer
resource "aws_lb_target_group" "app_tg" {
  name                        = "${var.ecs_configs.ecs.app_name}-tg"
  port                        = var.ecs_configs.ecs.aws_lb_target_group.port
  protocol                    = var.ecs_configs.ecs.aws_lb_target_group.protocol
  vpc_id                      = var.ecs_configs.ecs.vpc_id
  target_type                 = var.ecs_configs.ecs.aws_lb_target_group.target_type
  health_check {
    enabled                   = var.ecs_configs.ecs.aws_lb_target_group.health_check.enabled
    interval                  = var.ecs_configs.ecs.aws_lb_target_group.health_check.interval
    path                      = var.ecs_configs.ecs.aws_lb_target_group.health_check.path
    protocol                  = var.ecs_configs.ecs.aws_lb_target_group.health_check.protocol
    timeout                   = var.ecs_configs.ecs.aws_lb_target_group.health_check.timeout
    healthy_threshold         = var.ecs_configs.ecs.aws_lb_target_group.health_check.healthy_threshold
    unhealthy_threshold       = var.ecs_configs.ecs.aws_lb_target_group.health_check.unhealthy_threshold
    matcher                   = var.ecs_configs.ecs.aws_lb_target_group.health_check.matcher
  }
}

# Listener for the Network Load Balancer
resource "aws_lb_listener" "api_nlb_listener" {
  load_balancer_arn = var.lb_listener.arn
  protocol          = var.ecs_configs.ecs.aws_lb_listener.protocol
  port              = var.ecs_configs.ecs.aws_lb_listener.port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}


# ECS Service
resource "aws_ecs_service" "service" {
  name            = var.ecs_configs.ecs.ecs_service_name
  cluster         = var.rnt_aws_ecs_cluster.id
  task_definition = module.task_definition.aws_ecs_task_definition_arn
  desired_count   = var.ecs_configs.ecs.desired_count
  launch_type     = var.ecs_configs.ecs.launch_type
  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = var.ecs_configs.ecs.app_name
    container_port   =  var.ecs_configs.ecs.container_port
  }
  network_configuration {
    subnets          = var.ecs_configs.ecs.subnet_ids
    security_groups  = [var.rnt_app_security_group_id[1]]
    assign_public_ip = var.ecs_configs.ecs.assign_public_ip
  }
  #depends_on = [var.ecs_configs.ecs[0].aws_lb_listener]
  depends_on = [aws_lb_listener.api_nlb_listener]
}

#Alarm
module "alarm" {
  source                        = "../../modules/aws_ecs/alarm"
  ecs_cluster_name              = var.ecs_configs.ecs.cluster_name
  ecs_service_app_name          = var.ecs_configs.ecs.app_name
  error_pattern                 = "Error"
  log_group_name                = module.log_group.log_group_name
  aws_sns_topic_alarm_topic_arn = var.ecs_configs.ecs.aws_sns_topic_alarm_topic_arn
}
module "aws_vpc_endpoint" {
  source     = "../../modules/aws-vpc-endpoints"
  for_each   = { for entry in var.ecs_configs.ecs.vpc_endpoints : "${entry.vpc_id}=>${entry.service_name}" => entry }
  vpc_id            = each.value.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.vpc_endpoint_type
  subnet_ids        = [each.value.subnet_ids]
  security_group_ids = [var.rnt_app_security_group_id[0]]
}