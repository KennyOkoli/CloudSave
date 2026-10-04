resource "aws_launch_template" "container_compute" {
    instance_type = "t3.micro"
    image_id = "ami-0d27e0fb3bac4d724"
    key_name = aws_key_pair.cs_aws_public_pair.key_name
    security_group_names = [aws_security_group.ecs_ec2_sg.name]
    iam_instance_profile {
      name = aws_iam_instance_profile.ec2_instance_profile_ssm.name
    }
    user_data = filebase64("user_data_ecs_connect.sh")
}



resource "aws_security_group" "ecs_ec2_sg"{
    name = "ecs_ec2_sg"
    vpc_id = aws_vpc.CloudSave.id
}

resource "aws_security_group_rule" "ecs_ec2_sg_rules" {
    security_group_id = aws_security_group.ecs_ec2_sg.id
    type = "ingress"
    protocol = "tcp"
    cidr_blocks = [aws_vpc.CLoudSave.cidr_block]
    from_port = 443
    to_port = 433
}

resource "aws_security_group_rule" "ecs_ec2_sg_rules" {
    security_group_id = aws_security_group.ecs_ec2_sg.id
    type = "ingress"
    protocol = "tcp"
    cidr_blocks = [aws_vpc.CLoudSave.cidr_block]
    from_port = 80
    to_port = 80
}

resource "aws_security_group_rule" "ecs_ec2_sg_rules" {
    security_group_id = aws_security_group.ecs_ec2_sg.id
    type = "ingress"
    protocol = "tcp"
    cidr_blocks = [aws_vpc.CLoudSave.cidr_block]
    from_port = 22
    to_port = 22
}
/*resource "aws_autoscaling_group" "container_compute_scale" {
    name = "container_compute_scale"
    vpc_zone_identifier = aws_vpc.CloudSave.id
    availability_zones = aws_private_subnets[*].id

}*/