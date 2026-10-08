terraform{
    required_providers{
        aws ={
            source = "hashicorp/aws"
            version = "~>6.0"
        }
        local ={
            source = "hashicorp/local"
            version = "~>2.9"
        }
        tls = {
            source = "hashicorp/tls"
            version = "~>4.4"
        }
    }
}

provider "aws"{
    region = "af-south-1"
}


module "CS_compute"{
    source = "./CS_compute"
    vpc_id = aws_vpc.CloudSave.id
    vpc_cidr = aws_vpc.CloudSave.cidr_block
    private_subnet = aws_subnet.CS_private_subnet[*].id
    ec2_key = var.key_name
    public_ip = var.public_ip
    private_cidr_blocks = aws_subnet.CS_private_subnet[*].cidr_block
    azones = data.aws_availability_zones.africa_az.names
    account = var.account
    region = var.aws_region
    public_subnet = aws_subnet.CS_public_subnet[*].id
}