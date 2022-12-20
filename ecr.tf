resource "aws_ecr_repository" "openstor_repo" {
  name                 = "openstor"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
