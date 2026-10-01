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
    }
}

provider "aws"{
    region = "af-south-1"
}