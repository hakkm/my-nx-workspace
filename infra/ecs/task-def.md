# ECS Task Definition (task-def.json)

Purpose:
- Defines the ECS Fargate task for the backend demo service.
- Specifies container image, CPU/memory, logging, health checks, ports, and execution role.

Key fields:
- `family`: Logical name of the task definition.
- `containerDefinitions[0].image`: Docker image to run. Replace the placeholder tag with a real image tag.
- `cpu` / `memory`: Fargate task sizing (matching `requiresCompatibilities: ["FARGATE"]`).
- `logConfiguration`: Sends container logs to CloudWatch (`/ecs/backend-demo-task-definition`).
- `healthCheck`: Probes `http://localhost:8080/api/test/hello` inside the container.
- `portMappings`: Exposes TCP 8080.
- `executionRoleArn`: IAM role used by ECS to pull the image and write logs.

Replacing the image tag:
- The file ships with `"image": "khabirhakim/demo-backend:REPLACE_WITH_SHA"`. Replace `REPLACE_WITH_SHA` with the actual image tag (e.g., a commit SHA) before registering or deploying.

Example replacement using CI (GitHub Actions):

```sh
sed -e "s/REPLACE_WITH_SHA/${{ github.sha }}/" \
    infra/ecs/task-def.json > task-def.rendered.json
```

Tips:
- Ensure the `executionRoleArn` exists in the target AWS account/region and has the `AmazonECSTaskExecutionRolePolicy` attached.
- Keep `awslogs-region` aligned with your deployment region.
- If your app listens on a different port or path, update `portMappings.containerPort` and `healthCheck.command` accordingly.
- Consider pinning `runtimePlatform` and resource sizes to match your performance needs.
- For multiple containers, add more entries to `containerDefinitions` and reference them in your ECS service’s load balancer config.
