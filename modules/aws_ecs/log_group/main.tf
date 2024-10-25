resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/ecs/${var.app_name}-group"
  retention_in_days = var.retention_in_days
}