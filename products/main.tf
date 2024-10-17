module "iam" {
  source = "./modules/security/iam"
  ecs_auto_scale_role_name = var.ecs_auto_scale_role_name
}

module "security_groups" {
  source = "./modules/security/security_groups"
  app_port = 3000
  vpc_id = data.aws_vpc.main.id
}
module "alb" {
  source          = "./modules/alb"
  vpc_id          = data.aws_vpc.main.id
  public_subnet   = aws_subnet.public.*.id
  #security_groups = [aws_security_group.lb.id]
  security_groups = [module.security_groups.aws_security_group_ib.id]

}

module "ecs" {
  source                  = "./modules/ecs"
  fargate_cpu             = var.fargate_cpu
  fargate_memory          = var.fargate_memory
  app_count               = var.app_count
  app_port                = var.app_port
  aws_region              = var.aws_region
  #ecs_task_execution_role = aws_iam_role.ecs_task_execution_role.arn
  ecs_task_execution_role = module.iam.ecs_task_execution_role.arn
  aws_subnet_private = aws_subnet.private.*.id
  #ecs_security_groups = aws_security_group.ecs_tasks.id
  ecs_security_groups = module.security_groups.aws_security_group_ecs_tasks.id
  aws_alb_target_group = module.alb.aws_alb_target_group.id
  

}