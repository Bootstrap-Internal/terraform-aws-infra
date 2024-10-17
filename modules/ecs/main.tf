# main.tf

resource "aws_ecs_cluster" "main" {
  name = "rnt-core-api-cluster"
}

data "template_file" "rnt_app" {
  template = file("./modules/ecs/rnt_app.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "rnt-app-task"
  #execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = var.ecs_task_execution_role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.rnt_app.rendered
}

resource "aws_ecs_service" "main" {
  name            = "rnt-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_security_groups]
    subnets          = var.aws_subnet_private
    assign_public_ip = true
  }

  load_balancer {
    #target_group_arn = module.alb.aws_alb_target_group.arn
    target_group_arn = var.aws_alb_target_group
    container_name   = "rnt-app"
    container_port   = var.app_port
  }

  #depends_on = [module.alb.fornt_end_listner, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}