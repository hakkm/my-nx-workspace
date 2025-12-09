# -----------------------------------------------------------------------------
# 1. EXECUTION ROLE
# "The Butler": Pulls images, writes logs, handles the infrastructure side.
# -----------------------------------------------------------------------------
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.app_name}-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# Attach the standard AWS policy for execution (Logs + ECR Pull)
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# -----------------------------------------------------------------------------
# 2. TASK ROLE
# "The Bodyguard": Lives inside the container. Allows the app to talk to AWS.
# Required for: ECS Exec (debugging), S3 access, DB access, etc.
# -----------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.app_name}-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# -----------------------------------------------------------------------------
# 3. ECS EXEC POLICY (SSM)
# Allows you to run "aws ecs execute-command" and shell into the container.
# -----------------------------------------------------------------------------
resource "aws_iam_policy" "ecs_exec_policy" {
  name   = "${var.app_name}-exec-policy"
  description = "Allows ECS Exec for debugging"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the SSM policy to the TASK role
resource "aws_iam_role_policy_attachment" "ecs_exec_role_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_exec_policy.arn
}
