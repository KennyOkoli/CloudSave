/*resource "aws_launch_template" "container_compute" {
    instance_type = "t3.micro"
    image_id = "ami-0d27e0fb3bac4d724"
    key_name = aws_key_pair.cs_aws_public_pair.key_name
    security_group_names = []
    # Instance role profile

    user_data = file()
}

resource "aws_autoscaling_group" "container_compute_scale" {
    name = "container_compute_scale"
    vpc_zone_identifier = aws_vpc.CloudSave.id
    availability_zones = aws_private_subnets[*].id

}*/