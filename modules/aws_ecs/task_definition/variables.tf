variable "vpc_id" {
  description = "The id of the VPC"
  type        = string
}

variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "The name of the role that ECS tasks can assume."
  type        = string
}

variable "task_cpu" {
  description = "The number of CPU units used by the task."
  type        = string
}

variable "task_memory" {
  description = "The amount (in MiB) of memory used by the task."
  type        = string
}

variable "container_port" {
  description = "Port of the container"
  type        = number
}

variable "host_port" {
  description = "Port of the host"
  type        = number
}

variable "log_group_name" {
  description = "The name of the log group"
  type        = string
}


variable "log_group_region" {
  description = "The region of the log group"
  type        = string
}

variable "ecr_repository_url" {
  description = "The ECR repo URL"
  type        = string
}
