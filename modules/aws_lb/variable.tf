variable "aws_nlb_config" {
    type = object({
        name                          = string
        internal                      = bool
        load_balancer_type            = string      
        subnets                       = list(string)
        security_groups               = set(string)
        enable_deletion_protection    = bool
      }) 
}

variable "aws_lb_target_group" {
  type = object({
        name                          = string
        port                          = number      
        protocol                      = string      
        target_type                   = string      
        health_check =object({
          enabled                     = bool        
          interval                    = number      
          path                        = string      
          protocol                    = string      
          timeout                     = number      
          healthy_threshold           = number      
          unhealthy_threshold         = number      
          matcher                     = string      
        })
      })
}

variable "aws_lb_listener" {
    type = object({
        protocol                      = string      
        port                          = string
        default_action                = object({
          type = string                       
        })      
      }) 
}
variable "vpc_id" {
  description = "This is for VPC Id"
}