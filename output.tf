output "alb_dns_name" {
  value       = aws_lb.load_balancer[0].dns_name
  description = "the name of the load balance"
}