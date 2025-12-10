output "alb_dns_name" {
  description = "The URL of the load balancer"
  value       = "http://${aws_lb.main.dns_name}"
}

output "cloudfront_url" {
  description = "The main public URL for your application"
  value       = "https://${aws_cloudfront_distribution.main.domain_name}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket (for CI/CD upload)"
  value       = aws_s3_bucket.frontend.id
}

output "github_actions_role_arn" {
  description = "Put this in your GitHub Secret: AWS_ROLE_ARN"
  value       = aws_iam_role.github_actions.arn
}
