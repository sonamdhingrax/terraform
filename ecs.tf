resource "aws_ecs_cluster" "openstor_cluster" {
  name = "openstor_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


resource "aws_ecs_cluster_capacity_providers" "openstor_fargate" {
  cluster_name = aws_ecs_cluster.openstor_cluster.id

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}


resource "aws_ecs_task_definition" "openstor_task_definition" {
  family                   = "openstor_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name      = "openstor_container"
      image     = "${aws_ecr_repository.openstor_repo.repository_url}:v1"
      cpu       = 256
      memory    = 512
      essential = true
      portmappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
