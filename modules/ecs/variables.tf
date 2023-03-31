variable "env_prefix" {}

variable "vpc_id" {}

variable "fargate_cpu" {}

variable "fargate_memory" {}

variable "repo_url" {
    description = "ecr repo url"
}

variable "image_tag" {
    description = "image tag for task definition"
}

variable "container_cpu" {
    description = "container cpu"
}

variable "container_memory" {
    description = "container memory"
}

variable "container_port" {
    description = "container port"
}

variable "container_count" {
    description = "container count"
}

variable "alb_target_group_arn" {
    description = "applicaiton load balancer target group arn"
}

variable "private_subnet_id" {
    description = "private subnet id for ecs network"
}

variable "ecs_cluster_sg_id" {
    description = "ecs cluster security group id"
}

variable "pn-server-port" {
    description = "container port for load balancer"
}

variable "ecs_dependends_on_list" {
    description = "dependency list before creating ecs"
}
  









