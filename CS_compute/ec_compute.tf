variable "vpc_id"{
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "private_subnet" {
    type = list(string)
}

variable "public_ip" {
    type = string
}

resource "aws_launch_template" "container_compute" {
    instance_type = "t3.micro"
    image_id = "ami-0d13047a040c6a71a"
    key_name = aws_key_pair.cs_aws_public_pair.key_name
    vpc_security_group_ids = [aws_security_group.ecs_ec2_sg.id]
    iam_instance_profile {
      name = aws_iam_instance_profile.ec2_instance_profile_ssm.name
    }
    user_data = filebase64("${path.module}/user_data_ecs_connect.sh")
}


resource "aws_security_group" "ecs_ec2_sg"{
    name = "ecs_ec2_sg"
    vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ecs_ec2_sg_rule_443" {
    security_group_id = aws_security_group.ecs_ec2_sg.id
    type = "ingress"
    protocol = "tcp"
    cidr_blocks = [var.public_ip]
    from_port = 443
    to_port = 443
}

resource "aws_security_group_rule" "ecs_ec2_sg_rule_eph" {
    security_group_id = aws_security_group.ecs_ec2_sg.id
    type = "ingress"
    protocol = "tcp"
    cidr_blocks = [var.public_ip]
    from_port = 1024
    to_port = 65535
}

resource "aws_security_group_rule" "ecs_ec2_sg_rule_80" {
    security_group_id = aws_security_group.ecs_ec2_sg.id
    type = "ingress"
    protocol = "tcp"
    cidr_blocks = [var.public_ip]
    from_port = 80
    to_port = 80
}

resource "aws_security_group_rule" "ecs_ec2_sg_rule_22" {
    security_group_id = aws_security_group.ecs_ec2_sg.id
    type = "ingress"
    protocol = "tcp"
    cidr_blocks = [var.public_ip]
    from_port = 22
    to_port = 22
}

resource "aws_security_group_rule" "ecs_ec2_sg_rule_egr" {
    security_group_id = aws_security_group.ecs_ec2_sg.id
    type = "egress"
    protocol = "tcp"
    cidr_blocks = [var.public_ip]
    from_port = 0
    to_port = 65535
}

resource "aws_autoscaling_group" "container_compute_scale" {
    name = "container_compute_scale"
    vpc_zone_identifier = var.private_subnet
    health_check_type = "EC2"
    health_check_grace_period = 300
    desired_capacity = 2
    min_size = 2
    max_size = 3

    launch_template {
      id = aws_launch_template.container_compute.id
      version = "$Latest"
    }
}
