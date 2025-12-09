resource "random_password" "alb_secret" {
  length  = 32
  special = false
}

output "secret_header_value" {
  description = "The secret header CloudFront sends to ALB"
  value       = random_password.alb_secret.result
  sensitive   = true
}
