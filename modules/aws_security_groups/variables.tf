# variable "vpc_id" {
#   description = "Id of the VPC"
#   type        = string
# }

variable "security_groups" {
  description = "List of security group configurations"
  type = list(object({
    name        = string
    description = string
    vpc_id      = string
    ingress     = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))
}


# variable "ecs_security_group" {
#   description = "This is the object for ecs security group"
#   type = object({
#     name = string
#     description = string
#     vpc_id = string
#     ingress = object({
#           from_port = string
#           to_port = string 
#           protocol = string
#           cidr_blocks = list(string)
#     })
#     egress = object({
#           from_port = string
#           to_port = string 
#           protocol = string
#           cidr_blocks = list(string)
#     })
#     tags = list(string)

#   })
  
# }