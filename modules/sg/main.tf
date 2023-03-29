# ALB security group: edit to restrict the access to the application 
resource "aws_security_group" "pn-server-alb-sg" {
  name        = "${var.env_prefix}-pn-server-alb-sg"
  description = "controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "${var.env_prefix}-pn-server-alb-sg"
  }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs-cluster-sg" {
  name        = "${var.env_prefix}-ecs-cluster-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "TLS from "
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.pn-server-alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-pn-server-ecs-cluster-sg"
  }
}

