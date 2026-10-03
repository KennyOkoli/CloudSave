data "aws_availability_zones" "africa_az"{
    state = "available"
}

resource "aws_vpc" "CloudSave" {
    cidr_block = var.CS_cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true
}

resource "aws_subnet" "CS_public_subnet"{
    count = 2
    vpc_id = aws_vpc.CloudSave.id
    cidr_block = "172.0.${count.index}.0/24"
    availability_zone = data.aws_availability_zones.africa_az.names[count.index]
    map_public_ip_on_launch = true
}

resource "aws_subnet" "CS_private_subnet"{
    count = 2
    vpc_id = aws_vpc.CloudSave.id
    cidr_block = "172.0.${count.index + 30}.0/24"
    availability_zone = data.aws_availability_zones.africa_az.names[count.index]
}

resource "aws_eips" "cs_eip" {
    count = 2
}

variable "nat_tags" {
    default = ["nat-af-1a", "nat-af-1b"]
}

resource "aws_nat_gateway" "cs_nat_gateway" {
    count = 2
    vpc_id = aws_vpc.CloudSave.id
    allocation_id = aws_eips.cs_eip[count.index].id
    subnet_id = aws_subnet.CS_public_subnet[count.index].id

    tags ={
        name = var.nat_tags[count.index]
    }
}

resource "aws_route_table" "CS_private-route"{
    count = 2
    vpc_id = aws_vpc.CloudSave.id
    route{
        cidr_block = ["0.0.0.0/0"]
        nat_gateway_id = aws_nat_gateway.cs_nat_gateway[count.index].id
    }
}

resource "aws_route_table_association" "route_private_subnet" {
    count = 2
    route_table_id = aws_route_table.CS_private-route.id
    subnet_id = aws_subnet.CS_private_subnet[*].id
}

resource "aws_network_acl" "CS_acl_private" {
    vpc_id = aws_vpc.CloudSave.id
    subnet_ids = aws_subnet.CS_private_subnet[*].id
    ingress {
        rule_no = 1
        #cidr_block = aws_
        action = "allow"
        protocol = "tcp"
        from_port = 1024
        to_port = 65535
    }
    ingress {
        rule_no = 2
        cidr_block = aws_vpc.CloudSave.cidr_block
        action = "allow"
        protocol = "tcp"
        from_port = 443
        to_port = 443
    }
    ingress {
        rule_no = 3
        cidr_block = aws_vpc.CloudSave.cidr_block
        action = "allow"
        protocol = "tcp"
        from_port = 80
        to_port = 80
    }
    ingress {
        rule_no = 4
        cidr_block = aws_vpc.CloudSave.cidr_block
        action = "allow"
        protocol = "tcp"
        from_port = 22
        to_port = 22
    }
    egress{
        rule_no = 1
        cidr_block = aws_vpc.CloudSave.cidr_block
        action = "allow"
        protocol = "tcp"
        from_port = 443
        to_port = 443
    }
    egress{
        rule_no = 2
        cidr_block = aws_vpc.CloudSave.cidr_block
        action = "allow"
        protocol = "tcp"
        from_port = 1024
        to_port = 65535
    }
    egress {
        rule_no = 3
        cidr_block = aws_vpc.CloudSave.cidr_block
        action = "allow"
        protocol = "tcp"
        from_port = 80
        to_port = 80
    }
    ingress {
        rule_no = 2
        cidr_block = aws_vpc.CloudSave.cidr_block
        action = "allow"
        protocol = "tcp"
        from_port = 22
        to_port = 22
    }
}

resource "aws_internet_gateway" "CS_gateway"{
    vpc_id = aws_vpc.CloudSave.id
}

resource "aws_route_table" "CS_public_route"{
    vpc_id = aws_vpc.CloudSave.id
    route {
        cidr_block = var.CS_public_ip
        gateway_id = aws_internet_gateway.CS_gateway.id
    }
}

resource "aws_network_acl" "CS_acl"{
    vpc_id = aws_vpc.CloudSave.id
    subnet_ids = aws_subnet.CS_public_subnet[*].id
    ingress{
        rule_no = 1
        protocol = "tcp"
        cidr_block = var.CS_public_ip
        action = "allow"
        from_port = 443
        to_port = 443
    }
    ingress{
        rule_no = 2
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        from_port = 443
        to_port = 443
    }
    ingress{
        rule_no = 3
        protocol = "tcp"
        cidr_block = var.CS_public_ip
        action = "allow"
        from_port = 80
        to_port = 80
    }
    ingress{
        rule_no = 4
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        from_port = 80
        to_port = 80
    }
    egress{
        rule_no = 1
        protocol = "tcp"
        cidr_block = var.CS_public_ip
        action = "allow"
        from_port = 1024
        to_port = 65535
    }
    egress{
        rule_no = 1
        protocol = "tcp"
        cidr_block = "0.0.0.0/0"
        action = "allow"
        from_port = 1024
        to_port = 65535
    }
}

resource "aws_route_table_association" "CS_route_public_subnet" {
    count = 2
    route_table_id = aws_route_table.CS_public_route.id
    subnet_id = aws_subnet.CS_public_subnet[count.index].id
}