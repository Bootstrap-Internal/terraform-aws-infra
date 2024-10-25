output "aws_ecs_task_definition_arn" {
  value = aws_ecs_task_definition.task_definition.arn
  description = "The ARN of the ecs task definition"
}