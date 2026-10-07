# Trust policy for ecs tasks
data "aws_iam_policy_document" "ecs_trust_policy"{
    statement {
      effect = "Allow"
      principals {
        type = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
      }
      actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "ecs_exec_role" {
    name = "ecs_exec_role"
    assume_role_policy = data.aws_iam_policy_document.ecs_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "esc_exec_policy_attachemnt" {
    role = aws_iam_role.ecs_exec_role.name
    policy_arn = aws_iam_policy.ecs_exec_policy.arn
}

resource "aws_iam_policy" "ecs_exec_policy"{
    name = "ecs_task_exec"
    path = "/"
    policy = data.aws_iam_policy_document.ecs_get_image_doc.json
}

data "aws_iam_policy_document" "ecs_get_image_doc" {
    statement {
        effect = "Allow"
        actions = [
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken"
        ]
        resources = [aws_ecr_repository.cloudsaveRegistry.arn] 
    }
}