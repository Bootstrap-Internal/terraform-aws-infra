# General outputs for all security groups
output "security_group_arns" {
  value       = { for k, sg in aws_security_group.app_sg : k => sg.arn }
  description = "The ARNs of all security groups"
}

output "security_group_ids" {
  value       = { for k, sg in aws_security_group.app_sg : k => sg.id }
  description = "The IDs of all security groups"
}


# Specific outputs using lookup for optional values
output "app_security_group_id" {
  value       = lookup(aws_security_group.app_sg, "app-sg", null).id
  description = "The ID of App security group, if exists"
}


output "elb_security_group_id" {
  value       = lookup(aws_security_group.app_sg, "elb-sg", null).id
  description = "The ID of ELB security group, if exists"
}


output "vpc_endpoint_security_group_id" {
  value       = lookup(aws_security_group.app_sg, "vpc-endpoint-sg", null).id
  description = "The ID of VPC Endpoint security group, if exists"
}
