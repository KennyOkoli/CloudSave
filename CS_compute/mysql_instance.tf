resource "aws_launch_template" "cs-container-instance"{
    instance_type = "t3.micro"
    image_id = "ami-0d27e0fb3bac4d724"
    vpc_security_group_ids = [aws_security_group.db_sg[*].id] 
    key_name = aws_key_pair.cs_aws_public_pair.key_name
}


resource "aws_security_group" "db_sg"{
    name = "db_sg"
    vpc_id = aws_vpc.CloudSave.id
}

resource "aws_security_group_rule" "db_sg_ingress_1"{
    type = "ingress"
    security_group_id = aws_security_group.db_sg.id
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
}

resource "aws_security_group_rule" "db_sg_ingress_2"{
    type = "ingress"
    security_group_id = aws_security_group.db_sg.id
    protocol = "tcp"
    from_port = 80
    to_port = 80
}

resource "aws_security_group_rule" "db_sg_ingress_3"{
    type = "ingress"
    security_group_id = aws_security_group.db_sg.id
    protocol = "tcp"
    from_port = 443
    to_port = 443
}

resource "aws_security_group_rule" "db_sg_ingress_4"{
    type = "ingress"
    security_group_id = aws_security_group.db_sg.id
    protocol = "tcp"
    from_port = 22
    to_port = 22
}