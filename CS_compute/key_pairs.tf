resource "tls_private_key" "Cloud_save_pair"{
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "cs_aws_public_pair"{
    key_name = "cs_key_pair"
    public_key = tls_private_key.local-key-pair.public_key_openssh
}

resource "local_file" "cs_private_key" {
  content = tls_private_key.local-key-pair.private_key_pem
  filename = "cs_private_key"
}

resource "local_file" "cs_public_key" {
  content = tls_private_key.local-key-pair.public_key_openssh
  filename = "cs_pub_key"
}