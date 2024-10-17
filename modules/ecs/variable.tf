variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "bradfordhamilton/crystal_blockchain:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"

}
variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
}
variable "aws_region" {
  description = "The AWS region things are created in"
}
variable "app_count" {
  description = "Number of docker containers to run"
}
variable ecs_task_execution_role {
  description = "This is ecs task execution role"
}
variable "ecs_security_groups" {
  description = "This is the ecs security group"  
}
variable "aws_alb_target_group" {
  description = "This is the alb target group"  
}
variable "aws_subnet_private" {
  description = "This is the alb target group" 
}