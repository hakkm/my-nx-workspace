# 1. Create the OIDC Provider (The Bridge between GitHub and AWS)
# This lets GitHub prove who it is without needing permanent Access Keys.

# Use this if you don't have an existing provider
#resource "aws_iam_openid_connect_provider" "github" {
#  url             = "https://token.actions.githubusercontent.com"
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
#}
# Read the existing provider instead of creating it
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# 2. The IAM Role for GitHub Actions
# This is the identity your pipeline assumes.
resource "aws_iam_role" "github_actions" {
  name = "${var.app_name}-github-actions-role"

  # The Trust Policy: "Only allow THIS specific Repo to assume this role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          # uncomment this line if you created a new provider
          # Federated = aws_iam_openid_connect_provider.github.arn
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
        }
      }
    ]
  })
}

# 3. Policy A: Backend Permissions (ECS + Docker)
resource "aws_iam_policy" "github_backend_policy" {
  name        = "${var.app_name}-github-backend-policy"
  description = "Permissions to deploy the Backend (ECS)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Register new Task Definitions
      {
        Effect   = "Allow"
        Action   = [
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeTaskDefinition"
        ]
        Resource = "*" # Needs * because new task def ARNs are random
      },
      # Update the Service to use the new Task
      {
        Effect   = "Allow"
        Action   = ["ecs:UpdateService", "ecs:DescribeServices"]
        Resource = [aws_ecs_service.backend.id]
      },
      # Pass the Execution/Task Roles to the new Task
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = [
          aws_iam_role.ecs_execution_role.arn,
          aws_iam_role.ecs_task_role.arn
        ]
      }
    ]
  })
}

# 4. Policy B: Frontend Permissions (S3 + CloudFront)
resource "aws_iam_policy" "github_frontend_policy" {
  name        = "${var.app_name}-github-frontend-policy"
  description = "Permissions to deploy the Frontend (S3 + CDN)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Sync files to S3 (Upload + Delete old files)
      {
        Effect   = "Allow"
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.frontend.arn,
          "${aws_s3_bucket.frontend.arn}/*"
        ]
      },
      # Invalidate CloudFront Cache (So users see changes instantly)
      {
        Effect   = "Allow"
        Action   = ["cloudfront:CreateInvalidation", "cloudfront:GetInvalidation"]
        Resource = [aws_cloudfront_distribution.main.arn]
      }
    ]
  })
}

# 5. Attach Policies to the Role
resource "aws_iam_role_policy_attachment" "attach_backend" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_backend_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_frontend" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_frontend_policy.arn
}
