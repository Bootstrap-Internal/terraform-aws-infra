variable "ecs_configs" {
  description = "Parameters for ECS Setup"
  type = object({
    ecs = object({
      vpc_id                        = string
      region                        = string
      subnet_ids                    = list(string)
      ecr_repo_name                 = string
      image_tag                     = string
      app_name                      = string
      ecs_service_name              = string
      log_retention_in_days         = number
      cluster_id                    = string
      cluster_name                  = string
      desired_count                 = number
      launch_type                   = string        #"FARGATE"
      nlb_type                      = string
      container_port                = number
      api_nlb_name                  = string
      security_group_ids            = list(string)
      lb_listener                   = string
      assign_public_ip              = bool
      share_tgw                     = bool
      ecs_task_execution_role_name  = string
      aws_sns_topic_alarm_topic_arn = string
      vpc_endpoints                 = list(object({
        vpc_id                      = string
        vpc_endpoint_type           = string
        service_name                = string
        subnet_ids                  = list(string)
      }))
      task_definition = object({
        task_cpu                      = number
        task_memory                   = number
        host_port                     = number
        #ecs_task_execution_role_arn   = string
        log_group_region              = string
      })
      aws_lb = object({
        api_lb_name                   = string
        lb_type                       = string   
        lb_internal                   = bool   
        enable_deletion_protection    = bool
        subnet_ids                    = list(string)
      })      
      aws_lb_target_group = object({
        name                          = string
        port                          = number      #80
        protocol                      = string      #"TCP"
        target_type                   = string      #"ip"
        health_check =object({
          enabled                     = bool        #true
          interval                    = number      #30
          path                        = string      #"/"
          protocol                    = string      #"HTTP"
          timeout                     = number      #5
          healthy_threshold           = number      #2
          unhealthy_threshold         = number      #2
          matcher                     = string      #"200"
        })
      })
      aws_lb_listener = object({
        protocol                      = string      #"TCP"
        port                          = string      #"80"
        default_action                = object({
          type = string                       
        })   
      })
    })
  })
}
# variable "lb_listener" {
#   description = "The load balancer listener"
# }
variable "ecs_task_execution_role_arn" {
  description = "The task execution role"
}

# variable "rnt_app_security_group_id" {
#   description = "The security group arn for ecs"
#   type = list(string)
# }
variable "rnt_aws_ecs_cluster" {
  description = "rnt ecs cluster details"  
}

variable "my_api_gateway_config" {
  description = "Configuration for multiple APIs, each with its methods and integrations"
  type = list(object({
    api = object({
      name       = string
      methods    = list(object({
        http_method   = string
        authorization = string
      }))
      integrations = list(object({
        http_method             = string
        integration_http_method = string
        type                    = string
        uri                     = string
        connection_type         = string
        connection_id           = string
      }))
      cors = optional(object({
        allow_origin  = string
        allow_headers = string
        allow_methods = string
      }))
    })
  }))
  default = []
}

variable "my_security_groups" {
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
