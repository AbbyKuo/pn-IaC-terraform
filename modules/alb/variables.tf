variable "env_prefix" {
    description = "environment prefix"
}

variable "vpc_id" {
    description = "vpc id"
}

variable "health_check_path" {
    description = "backend server health check path"
}

variable "alb_sg_id" {
    description = "application load balancer security group id"
}

variable "public_subnet_id" {
    description = "public subnet id/s"
}

variable "certificate_arn" {
    description = "certificate arn for the root domian wildcard"
}
