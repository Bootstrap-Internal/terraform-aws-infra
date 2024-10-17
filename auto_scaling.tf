# auto_scaling.tf

resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${module.ecs.aws_ecs_cluster.name}/${module.ecs.aws_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  #role_arn           = aws_iam_role.ecs_auto_scale_role.arn
  role_arn           = module.iam.ecs_auto_scale_role.arn
  min_capacity       = 3
  max_capacity       = 6
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
  name               = "rnt_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${module.ecs.aws_ecs_cluster.name}/${module.ecs.aws_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
  name               = "rnt_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${module.ecs.aws_ecs_cluster.name}/${module.ecs.aws_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "rnt_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = module.ecs.aws_ecs_cluster.name
    ServiceName = module.ecs.aws_ecs_service.name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "rnt_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = module.ecs.aws_ecs_cluster.name
    ServiceName = module.ecs.aws_ecs_service.name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}