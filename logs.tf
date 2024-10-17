# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "rnt_log_group" {
  name              = "/ecs/rnt-app"
  retention_in_days = 30

  tags = {
    Name = "rnt-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "rnt_log_stream" {
  name           = "rnt-log-stream"
  log_group_name = aws_cloudwatch_log_group.rnt_log_group.name
}