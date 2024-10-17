output "alb_hostname" {
  value = "${aws_alb.main.dns_name}:3000"
}

output "fornt_end_listner" {
  value = aws_alb_listener.front_end
}

output "aws_alb_target_group" {
  value = aws_alb_target_group.app
}