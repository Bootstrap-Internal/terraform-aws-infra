# # Security Group for the ECS Tasks
# resource "aws_security_group" "app_sg" {
#   name        = "app-sg"
#   description = "Allow traffic to ECS tasks"
#   vpc_id      = var.vpc_id
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#    tags = {
#     Name = "app-sg"
#   }
# }

# # Security Group for the ELB
# resource "aws_security_group" "elb_sg" {
#   name        = "elb-sg"
#   description = "Security group for ELB"
#   vpc_id      = var.vpc_id

#   # Allow incoming traffic only from the API Gateway security group
#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow all outgoing traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "elb-sg"
#   }
# }
# # Security group for VPC end point
# resource "aws_security_group" "vpc_endpoint_sg" {
#   name        = "vpc-endpoint-sg"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["10.66.1.0/24"] 
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


resource "aws_security_group" "app_sg" {
  for_each    = { for sg in var.security_groups : sg.name => sg }
  name        = each.value.name
  description = each.value.description
  vpc_id      = each.value.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = each.value.tags
}
