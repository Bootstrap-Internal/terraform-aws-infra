variable "health_check_path" {
  default = "/"
}
variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default = 3000

}
variable "vpc_id" {
  description = "The ID of the VPC in which the ALB will be created"
  type        = string
}

variable "security_groups" {
  description = "The is for security group"
  type        = set(string)
}

variable "public_subnet" {
  description = "The is public subnet"
  type        = list(string)
}
