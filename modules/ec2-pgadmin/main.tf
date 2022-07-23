# ================ Security Groups ================
module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "pgadmin4-instance-security-group"
  description = "Security group for ec2_sg"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "pgadmin4-application-loadbalancer-security-group"
  description = "Security group for ec2_sg"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}


# ================ Ec2 Instances ================
data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_iam_role" "this" {
  name = "ec2-iam-role-sendcloud"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "ec2-iam-role-sendcloud"
  }
}

resource "aws_key_pair" "this" {
  key_name   = "pgadmin-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = tomap({
    One = var.private_subnets_cidr_blocks[0]
    Two = var.private_subnets_cidr_blocks[1]
  })

  name = "pgadmin-server-${each.key}"
  user_data = <<-EOF
    #!/bin/bash
    set -ex
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    usermod -a -G docker ec2-user
    curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    mkdir /data && chown docker:docker /data
    mount /dev/sdh /data
    mkdir /data/pgadmin
    docker pull dpage/pgadmin4
    docker run -p 80:80 \
    -v /data/pgadmin:/var/lib/pgadmin \
    -e 'PGADMIN_DEFAULT_EMAIL=${var.pgadmin_admin_email}' \
    -e 'PGADMIN_DEFAULT_PASSWORD=${var.pgadmin_admin_password}' \
    -d dpage/pgadmin4
  EOF

  ami                    = aws_ami.this.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.this.id
  monitoring             = true
  vpc_security_group_ids = [ec2_sg.this.id]
  subnet_id              = each.value

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.ec2.id

}

resource "aws_ebs_volume" "this" {
  availability_zone = local.availability_zone
  size              = 20
  multi_attach_enabled = true

  tags = local.tags
}

# ================ Load Balancer ================

resource "aws_lb" "this" {
  name               = "pgadmin-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Environment = "development"
    Name = "pgadmin-alb"
  }
}