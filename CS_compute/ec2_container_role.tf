data "aws_iam_policy_document" "trust_policy_ec2"{
    statement {
      effect = "Allow"
      principals{
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }
      actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "ec2_role_ssm_ecs" {
     name = "ec2_role_ssm_ecs"
     assume_role_policy = data.aws_iam_policy_document.trust_policy_ec2.json
}



resource "aws_iam_role_policy_attachment" "ec2_profile_policy" {
    role = aws_iam_role.ec2_role_ssm_ecs.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_profile_ecs_policy"{
    role = aws_iam_role.ec2_role_ssm_ecs.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance_profile_ssm" {
    name = "ec2_instance_profile_ssm"
    role = aws_iam_role.ec2_role_ssm_ecs.name   
}