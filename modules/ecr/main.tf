resource "aws_ecr_repository" "api" {
  name                 = "${var.project_name}-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-api"
  }
}

resource "aws_ecr_repository" "tenant" {
  name                 = "${var.project_name}-tenant"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-tenant"
  }
}

resource "aws_ecr_repository" "hq" {
  name                 = "${var.project_name}-hq"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-hq"
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  for_each = toset([
    aws_ecr_repository.api.name,
    aws_ecr_repository.tenant.name,
    aws_ecr_repository.hq.name
  ])

  repository = each.value

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 30 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 30
      }
      action = {
        type = "expire"
      }
    }]
  })
}
