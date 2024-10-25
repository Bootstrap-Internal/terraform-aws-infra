resource "aws_cloudwatch_metric_alarm" "running_less_than_desired" {
  alarm_name          = "${var.ecs_service_app_name}-running-less-than-desired"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "RunningCount"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Triggered when the running count is less than the desired count."
  alarm_actions       = ["${var.aws_sns_topic_alarm_topic_arn}"]

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_app_name
  }
}

resource "aws_cloudwatch_log_metric_filter" "service_failure" {
  name           = "${var.ecs_service_app_name}-service-failure"
  pattern        = "failed"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "ServiceFailureCount"
    namespace = "Custom"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "service_failure_alarm" {
  alarm_name          = "${var.ecs_service_app_name}-service-failure-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ServiceFailureCount"
  namespace           = "Custom"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Triggered when service failures are detected."
  alarm_actions       = ["${var.aws_sns_topic_alarm_topic_arn}"]
}

resource "aws_cloudwatch_log_metric_filter" "error_keyword" {
  name           = "${var.ecs_service_app_name}-error-keyword"
  pattern        = var.error_pattern
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "ErrorKeywordCount"
    namespace = "Custom"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_keyword_alarm" {
  alarm_name          = "${var.ecs_service_app_name}-error-keyword-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ErrorKeywordCount"
  namespace           = "Custom"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Triggered when 'error' keyword is found in logs."
  alarm_actions       = ["${var.aws_sns_topic_alarm_topic_arn}"]
}
