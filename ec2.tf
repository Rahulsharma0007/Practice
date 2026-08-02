
#region
provider "aws" {

region = "ap-south-1"

}

#key value pair


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIrElz4t4tSRKeUQ6IN8D5QhWnqJSiRKSg+W9Q07b5zz rahul@DESKTOP-VKRMBR2"
}

#VPC

resource "aws_default_vpc" "default" {
 
}

# security group

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_default_vpc.default.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


#EC2 instance

resource "aws_instance" "example" {
	tags = {  
name = "Terra-auto-server"
}
  ami           = "ami-0aba19e56f3eaec05"
  instance_type = "t3.micro"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
#storage
  root_block_device {
    volume_size           = 10
     volume_type           = "gp3"


}
}
