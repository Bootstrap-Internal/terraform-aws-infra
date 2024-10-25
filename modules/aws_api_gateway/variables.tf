variable "vpc_id" {
  description = "The id of the VPC"
  type        = string
}

variable "lb_listener" {
  description = "The load balancer listener"
}

variable "region" {
  description = "The region of the API gateway"
}