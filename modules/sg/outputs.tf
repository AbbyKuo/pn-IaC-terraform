output "alb-sg" {
  value = aws_security_group.pn-server-alb-sg
}

output "ecs-cluster-sg-id" {
  value = aws_security_group.ecs-cluster-sg.id
}
