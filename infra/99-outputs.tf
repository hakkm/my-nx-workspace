output "alb_dns_name" {
  description = "The URL of the load balancer"
  value       = "http://${aws_lb.main.dns_name}"
}
