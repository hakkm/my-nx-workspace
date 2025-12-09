variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "The name of the application (used for tagging and naming resources)"
  type        = string
  default     = "backend-demo"
}

variable "container_image" {
  description = "The Docker image to deploy"
  type        = string
  default     = "khabirhakim/demo-backend:latest"
}

variable "container_port" {
  description = "The port the container listens on"
  type        = number
  default     = 8080
}

variable "fargate_cpu" {
  description = "Fargate CPU units (256, 512, 1024)"
  type        = number
  default     = 512
}

variable "fargate_memory" {
  description = "Fargate Memory in MB"
  type        = number
  default     = 1024
}

variable "health_check_path" {
  description = "The path for the health check"
  type        = string
  default     = "/api/test/hello"
}

variable "github_repo" {
  description = "The GitHub repository in 'owner/repo' format (e.g., khabirhakim/monorepo-rabbit-hole)"
  type        = string
}
