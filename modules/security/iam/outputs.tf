output "ecs_task_execution_role" {
  value = aws_iam_role.ecs_task_execution_role
}
output "ecs_auto_scale_role" {
  value = aws_iam_role.ecs_auto_scale_role
}