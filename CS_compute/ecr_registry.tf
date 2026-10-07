resource "aws_ecr_repository" "cloudsaveRegistry" {
    name = "cloudsave-repo"
    image_tag_mutability = "MUTABLE"
}
