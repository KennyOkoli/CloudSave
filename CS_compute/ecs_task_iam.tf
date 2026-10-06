# Trust policy for ecs tasks
/*data "aws_iam_policy_document" "ecs_trust_policy"{
    statement {
      effect = "allow"
      principals {
        type = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
      }
      actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "cs_task_role" {
    name = "cs_task_role"
    assume_role_policy = data.aws_iam_policy_document.ecs_trust_policy.json
}

resource "aws_iam_policy" "cs_policy"{}*/


/*resource "aws_iam_policy" "ecs_task_exec"{
    name = "ecs_task_exec"
    path = "/containers"
    policy = data.aws_iam_policy_document.ecs_get_image_doc.json
}

data "aws_iam_policy_document" "ecs_get_image_doc" {
    statement {
        effect = "allow"
        actions = [
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken"
        ]
        resources = ["arn:aws:ecr:af-south-1:871145212791:repo_name/"] # Set the repo name, also look up global variables
    }
}*/