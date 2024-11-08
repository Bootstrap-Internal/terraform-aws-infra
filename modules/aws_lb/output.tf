output "aws_my_lb" {
    value = aws_lb.api_nlb 
}
output "aws_lb_target_group" {
    value = aws_lb_target_group.app_tg
}
output "aws_lb_listener" {
  value = aws_lb_listener.api_nlb_listener
}