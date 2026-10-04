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
}