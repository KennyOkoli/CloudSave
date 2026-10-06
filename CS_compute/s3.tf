/*resource "aws_s3_bucket" "cloudSaveBucket"{
    bucket = "cloud-save-bucket"
}


resource "aws_s3_bucket_policy" "cloudsave_bucket_policy" {
    bucket = aws_s3_bucket.cloudSaveBucket.id
    policy = jsonencode({
        "Version": "2012:10:17",
        "Statement": [
            {   Effect: "Allow",
                Principal: {
                    AWS: aws_iam_role.ec2_instance_role.arn
                },
                Action: [
                    "s3:ListBucket",
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:DeleteObject"
                    ],
                Resource:[
                    aws_s3_bucket.cloudSaveBucket.arn,
                    "${aws_s3_bucket.cloudSaveBucket.arn}/*"
                ]
            }
        ]
    })
}

variable "account" {
    type = string
}
variable "region" {
    type = string
}
*/