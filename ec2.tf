# AWS KEYPAIR

resource "tls_private_key" "awsnetblog_vpc_01-privatekey_01" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" {
    command = "echo '${tls_private_key.awsnetblog_vpc_01-privatekey_01.public_key_openssh}' > ./awsnetblog_vpc_01-publickey_01.key"
  }

  provisioner "local-exec" {
    command = "echo '${tls_private_key.awsnetblog_vpc_01-privatekey_01.private_key_pem}' > ./awsnetblog_vpc_01-privatekey_01.pem"
  }
}

resource "aws_key_pair" "awsnetblog_vpc_01-keypair_01" {
  key_name   = "awsnetblog_vpc_01-keypair_01"
  public_key = tls_private_key.awsnetblog_vpc_01-privatekey_01.public_key_openssh

  tags = {
    "Name"    = "awsnetblog_vpc_01-keypair_01"
    "Project" = var.project
  }
}


# PUBLIC SUBNET EC2

resource "aws_instance" "awsnetblog_vpc_01-subnet_01_public-ec2_01" {
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.awsnetblog_vpc_01-subnet_01_public.id
  key_name      = aws_key_pair.awsnetblog_vpc_01-keypair_01.key_name

  vpc_security_group_ids = [
    aws_security_group.awsnetblog_vpc_01-subnet_01_public-sg_01.id
  ]

  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_01_public-ec2_01"
    "Project" = var.project
  }
}

resource "aws_eip" "awsnetblog_vpc_01-subnet_01_public-ec2_01-eip_01" {
  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_01_public-ec2_01-eip_01"
    "Project" = var.project
  }
}

resource "aws_eip_association" "awsnetblog_vpc_01-subnet_01_public-ec2_01-eip_01-ec2_assoc" {
  instance_id   = aws_instance.awsnetblog_vpc_01-subnet_01_public-ec2_01.id
  allocation_id = aws_eip.awsnetblog_vpc_01-subnet_01_public-ec2_01-eip_01.id
}

resource "aws_security_group" "awsnetblog_vpc_01-subnet_01_public-sg_01" {
  name        = "awsnetblog_vpc_01-subnet_01_public-sg_01"
  description = "Allow public EC2 traffic"
  vpc_id      = aws_vpc.awsnetblog_vpc_01.id

  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_01_public-sg_01"
    "Project" = var.project
  }
}

resource "aws_security_group_rule" "awsnetblog_vpc_01-subnet_01_public-sg_01-sgrule_01" {
  type              = "egress"
  description       = "Allow egress HTTP on 80"
  security_group_id = aws_security_group.awsnetblog_vpc_01-subnet_01_public-sg_01.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "awsnetblog_vpc_01-subnet_01_public-sg_01-sgrule_02" {
  type              = "egress"
  description       = "Allow egress HTTP 443"
  security_group_id = aws_security_group.awsnetblog_vpc_01-subnet_01_public-sg_01.id

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "awsnetblog_vpc_01-subnet_01_public-sg_01-sgrule_05" {
  type              = "ingress"
  description       = "Allow ingress SSH"
  security_group_id = aws_security_group.awsnetblog_vpc_01-subnet_01_public-sg_01.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "awsnetblog_vpc_01-subnet_01_public-sg_01-sgrule_06" {
  type              = "egress"
  description       = "Allow egress SSH"
  security_group_id = aws_security_group.awsnetblog_vpc_01-subnet_01_public-sg_01.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.1.0.0/16"]
}


# PRIVATE SUBNET EC2

resource "aws_instance" "awsnetblog_vpc_01-subnet_02_private-ec2_01" {
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.awsnetblog_vpc_01-subnet_02_private.id
  key_name      = aws_key_pair.awsnetblog_vpc_01-keypair_01.key_name

  vpc_security_group_ids = [
    aws_security_group.awsnetblog_vpc_01-subnet_02_private-sg_01.id
  ]

  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_02_private-ec2_01"
    "Project" = var.project
  }
}

resource "aws_security_group" "awsnetblog_vpc_01-subnet_02_private-sg_01" {
  name        = "awsnetblog_vpc_01-subnet_02_private-sg_01"
  description = "Allow private EC2 traffic"
  vpc_id      = aws_vpc.awsnetblog_vpc_01.id

  tags = {
    "Name"    = "awsnetblog_vpc_01-subnet_02_private-sg_01"
    "Project" = var.project
  }
}

resource "aws_security_group_rule" "awsnetblog_vpc_01-subnet_02_private-sg_01-sgrule_01" {
  type              = "ingress"
  description       = "Allow ingress SSH"
  security_group_id = aws_security_group.awsnetblog_vpc_01-subnet_02_private-sg_01.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.1.0.0/16"]
}

resource "aws_security_group_rule" "awsnetblog_vpc_01-subnet_02_private-sg_01-sgrule_02" {
  type              = "egress"
  description       = "Allow egress SSH"
  security_group_id = aws_security_group.awsnetblog_vpc_01-subnet_02_private-sg_01.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.1.0.0/16"]
}
