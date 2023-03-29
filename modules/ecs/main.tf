# ECS task execution role and policy
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_policy" "ecs_task_execution_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

# ECS cluster
resource "aws_ecs_cluster" "pn-server-cluster" {
  name = "${var.env_prefix}-pn-server-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Task definition
resource "aws_ecs_task_definition" "pn-server-task-definition" {
  family                   = "${var.env_prefix}-pn-server-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "${var.env_prefix}-pn-server-container",
    "image": "${var.repo_url}:${var.image_tag}",
    "cpu": ${var.container_cpu},
    "memory": ${var.container_memory},
    "portMappings": [
        {
          "containerPort": ${var.container_port}
        }
      ],
    "essential": true
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = {
    "Name" = "${var.env_prefix}-pn-server-task-definition"
  }
}

# Service 
resource "aws_ecs_service" "pn-server-service" {
  name                              = "${var.env_prefix}-pn-server-service"
  cluster                           = aws_ecs_cluster.pn-server-cluster.arn
  task_definition                   = aws_ecs_task_definition.pn-server-task-definition.arn
  desired_count                     = var.container_count
  health_check_grace_period_seconds = 30
  launch_type                       = "FARGATE"
  platform_version                  = "LATEST"

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    # aws_lb_target_group.pn-server-alb-tg.arn
    container_name   = "${var.env_prefix}-pn-server-container"
    container_port   = var.pn-server-port
  }

  network_configuration {
    subnets          = var.private_subnet_id
    # [aws_subnet.pn-server-private-subnet[0].id, aws_subnet.pn-server-private-subnet[1].id]
    security_groups  = [var.ecs_cluster_sg_id]
    # [aws_security_group.ecs-cluster-sg.id]
    assign_public_ip = true

  }

  depends_on = [
    var.ecs_dependends_on_list
    # aws_alb_listener.https-alb
  ]

  tags = {
    "Name" = "${var.env_prefix}-pn-server-service"
  }

}


