/*data "aws_iam_policy_document" "trust_policy_ec2"{
    statement {
      effect = "Allow"
      principals{
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }
      actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "ec2_instance_role" {
     name = "ec2_instance_role"
     assume_role_policy = data.aws_iam_policy_document.trust_policy_ec2.json
}

resource "aws_iam_role_policy_attachment" "ec2_profile_policy" {
    role = aws_iam_role.ec2_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_profile_ecs_policy"{
    role = aws_iam_role.ec2_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_policy" "use_s3" {
    name = "use_s3"
    policy = jsonencode({
            "Version": "2012-10-17",
            "Statement": [
            {
                "Sid": "ConnectToBucket",
                "Action": [
                    "s3:ListBucket"
                ],
                "Effect": "Allow",
                "Resource": [aws_s3_bucket.cloudSaveBucket.arn]
            },                
                {
                "Sid": "ConnectToObjects",
                "Action": [
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:DeleteObject"
                ],
                "Effect":"Allow",
                "Resource": ["${aws_s3_bucket.cloudSaveBucket.arn}/*"]
            }]
})
}

resource "aws_iam_role_policy_attachment" "ec2_role_s3" {
    role = aws_iam_role.ec2_instance_role.name
    policy_arn = aws_iam_policy.use_s3.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "ec2_instance_profile"
    role = aws_iam_role.ec2_instance_role.name   
}
*/