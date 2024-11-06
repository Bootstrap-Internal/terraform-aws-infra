variable "aws_sns_topic_alarm_topic_arn" {
  description = "The ARN of the SNS alarm topic."
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  type = string
}

variable "ecs_service_app_name" {
  description = "The number of app running in ECS."
  type        = string
}

variable "log_group_name" {
  description = "The name of the log group."
  type        = string
}

variable "error_pattern" {
  description = "The pattern of the error in app."
  type        = string
}
