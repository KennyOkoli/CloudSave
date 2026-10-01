data "aws_iam_policy_document" "use-s3-policy"{
    statement{
        actions = [
            "s3:ListBucket",
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:GetBucketPolicy"
        ]
        effect = "Allow"
        resources = ["arn:aws:s3:${var.aws_region}:${var.account}:CS_s3/*"]
       }
    statement{
        actions = ["iam:ChangePassword"]
        effect = "Allow"
        resources = ["*"]
    }
}

resource "aws_iam_user" "Jeff"{
    name = "Jeff"
}

resource "aws_iam_access_key" "user_jeff_key"{
    user = aws_iam_user.Jeff.name
}

resource "aws_iam_user_login_profile" "user_jeff_login" {
    user = aws_iam_user.Jeff.name
    password_reset_required = true
}

resource "aws_iam_user_policy" "user_jeff_policy" {
    name = "accessS3_jeff"
    user = aws_iam_user.Jeff.name
    policy = data.aws_iam_policy_document.use-s3-policy.json
}

resource "local_file" "jeffs_credentials"{
    content = jsonencode({
    node_sdk = "aws-sdk"
    user_name = aws_iam_user.Jeff.name
    login_temporary_password = aws_iam_user_login_profile.user_jeff_login.password
    access_key = aws_iam_access_key.user_jeff_key.id
    secret_key = aws_iam_access_key.user_jeff_key.secret
    })

    filename = "jeffs_credentials.json"
}