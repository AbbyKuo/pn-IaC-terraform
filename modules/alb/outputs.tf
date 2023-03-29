output "alb_target_group" {
  value = aws_lb_target_group.pn-server-alb-tg
}

output "alb" {
  value = aws_lb.pn-server-alb
}

output "alb_listener_https_alb" {
  value = aws_alb_listener.https-alb
}
