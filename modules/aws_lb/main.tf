# Network Load Balancer for API Gateway VPC Link
resource "aws_lb" "api_nlb" {
  name                       = var.aws_nlb_config.name
  internal                   = var.aws_nlb_config.internal
  load_balancer_type         = var.aws_nlb_config.load_balancer_type
  subnets                    = var.aws_nlb_config.subnets
  security_groups            = var.aws_nlb_config.security_groups
  enable_deletion_protection = var.aws_nlb_config.enable_deletion_protection
}

# Target Group for the Network Load Balancer
resource "aws_lb_target_group" "app_tg" {
  name                        = var.aws_lb_target_group.name
  port                        = var.aws_lb_target_group.port
  protocol                    = var.aws_lb_target_group.protocol
  vpc_id                      = var.vpc_id
  target_type                 = var.aws_lb_target_group.target_type
  health_check {
    enabled                   = var.aws_lb_target_group.health_check.enabled
    interval                  = var.aws_lb_target_group.health_check.interval
    path                      = var.aws_lb_target_group.health_check.path
    protocol                  = var.aws_lb_target_group.health_check.protocol
    timeout                   = var.aws_lb_target_group.health_check.timeout
    healthy_threshold         = var.aws_lb_target_group.health_check.healthy_threshold
    unhealthy_threshold       = var.aws_lb_target_group.health_check.unhealthy_threshold
    matcher                   = var.aws_lb_target_group.health_check.matcher
  }
}

# Listener for the Network Load Balancer
resource "aws_lb_listener" "api_nlb_listener" {
  load_balancer_arn = aws_lb.api_nlb.arn
  protocol          = var.aws_lb_listener.protocol
  port              = var.aws_lb_listener.port

  default_action {
    type             = var.aws_lb_listener.default_action.type
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}