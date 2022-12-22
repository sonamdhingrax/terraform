resource "aws_ecr_repository" "openstor_repo" {
  name                 = "openstor"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }
}
