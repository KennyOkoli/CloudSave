variable "vpc_id" {
    type = string
}

variable "db_subnet_tags" {
    default = ["db_subnet_1", "db_subnet_2"]
}

variable "vpc_cidr" {
    type = string
}

variable "private_cidr_blocks" {
    type = list(string)
}


resource "aws_db_instance" "CloudSave_db"{
    db_name = "CloudSave_db"
    engine = "mysql"
    engine_version = "~>8.4"
    instance_class = "t3.micro"
    storage_type = "gp3"
    allocated_storage = 20
    username = file("${path.module}/mysql_username.txt")
    password = file("${path.module}/mysql_password.txt")
    multi_az = false
    skip_final_snapshot = true
    vpc_security_group_ids = [aws_security_group.mysql_db_sg.id]
}

resource "aws_security_group" "mysql_db_sg" {
    name = "postgres_db_sg"
    vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "mysql_db_sg_rule"{
    security_group_id = aws_security_group.mysql_db_sg.id
    cidr_blocks = var.private_cidr_blocks
    type = "ingress"
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
}

resource "aws_security_group_rule" "mysql_db_sg_rule_eg"{
    security_group_id = aws_security_group.mysql_db_sg.id
    cidr_blocks = var.private_cidr_blocks
    type = "egress"
    protocol = "tcp"
    from_port = 1024
    to_port = 65535
}

resource "aws_subnet" "db_subnet" {
    count = 2
    vpc_id = var.vpc_id
    cidr_block = "172.0.${count.index + 200}.0/24"

    tags={
        name = var.db_subnet_tags[count.index]
    }
}

resource "aws_network_acl" "db_nacl" {
    vpc_id = var.vpc_id
    ingress{
        rule_no = 1
        protocol = "tcp"
        cidr_block = var.vpc_cidr
        action = "allow"
        from_port = 3306
        to_port = 3306
    }
     ingress{
        rule_no = 2
        protocol = "tcp"
        cidr_block = var.vpc_cidr
        action = "allow"
        from_port = 1024
        to_port = 65535
    }
    egress{
        rule_no = 1
        protocol = "tcp"
        cidr_block = var.vpc_cidr
        action = "allow"
        from_port = 3306
        to_port = 3306
    }
    egress{
        rule_no = 2
        protocol = "tcp"
        cidr_block = var.vpc_cidr
        action = "allow"
        from_port = 1024
        to_port = 65535
    }
}

resource "aws_network_acl_association" "db_subnet_to_nacl" {
    count = 2
    subnet_id = aws_subnet.db_subnet[count.index].id
    network_acl_id = aws_network_acl.db_nacl.id
}

resource "aws_route_table" "db_route" {
    vpc_id = aws_vpc.CloudSave.id
}

resource "aws_route_table_association" "db_subnet_to_route" {
    route_table_id = aws_route_table.db_route.id
    subnet_id = aws_subnet.db_subnet.id
}
