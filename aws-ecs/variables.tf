variable "project_name" {
  default     = "rnt-core-api-project"
  description = "Name of the project"
  type        = string
}

variable "ecs_iam_arn" {
  description = "this is for IAM role for ecs task execution"
  default     = "arn:aws:iam::390844737705:role/ecs_task_execution_role"

}