resource "aws_vpc_endpoint" "vpc_endpoint" {
    vpc_id = var.vpc_id
    vpc_endpoint_type = var.vpc_endpoint_type
    service_name = var.service_name
    subnet_ids = var.subnet_ids[0]
    security_group_ids = var.security_group_ids
}