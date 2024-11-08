# ECR Repository for storing Docker images
resource "aws_ecr_repository" "repo" {
  name                 = "${var.app_name}-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}