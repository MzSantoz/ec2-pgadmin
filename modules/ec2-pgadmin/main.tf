# ================ Security Groups ================

resource "aws_security_group" "alb_sg" {
  name        = "Allow traffic from Internet"
  description = "Allow internet inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Pgadmin4-ALB-Security-Group"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "Allow traffic from ALB"
  description = "Allow ALB inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    description = "Instance traffic from private subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_subnets_cidr_blocks[0]]
  }

  ingress {
    description = "Instance traffic from private subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_subnets_cidr_blocks[1]]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Pgadmin4-Ec2-Instance-Security-Group"
  }
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
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Effect": "Allow",
      "Sid": "First"
    },
  ]
}
EOF
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  tags = {
    Name = "ec2-iam-role-sendcloud"
  }
}

resource "aws_key_pair" "this" {
  key_name   = "pgadmin-key"
  public_key = var.instance_key
}
module "efs" {
  source = "cloudposse/efs/aws"
  version     = "0.32.7"

  namespace = "sendcloud"
  stage     = "development"
  name      = "pgadmin-filesystem"
  region    = "us-east-1"
  vpc_id    = var.vpc_id
  subnets   = var.private_subnets
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = {
    One = var.private_subnets[0]
    Two = var.private_subnets[1]
  }

  name      = "pgadmin-server-${each.key}"
  user_data_base64 = <<-EOT
    #!/bin/bash
    sudo mkdir -p /mnt/efs
    sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${module.efs.dns_name}:/ /mnt/efs
    sudo su -c \"echo '${module.efs.dns_name}:/ /mnt/efs nfs4 defaults,vers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 0 0' >> /etc/fstab\"
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo mkdir /mnt/efs/pgadmin
    docker pull dpage/pgadmin4
    docker run -p 80:80 -v /mnt/efs/pgadmin:/var/lib/pgadmin -e 'PGADMIN_DEFAULT_EMAIL=${var.pgadmin_admin_email}' -e 'PGADMIN_DEFAULT_PASSWORD=${var.pgadmin_admin_password}' -d dpage/pgadmin4
  EOT

  ami                    = data.aws_ami.this.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.id
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ec2_sg.id, module.efs.security_group_id]
  subnet_id              = each.value
  iam_instance_profile  = aws_iam_role.this.name

  tags = {
    Terraform   = "true"
    Environment = "development"
  }
}

# ================ Load Balancer ================

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  for_each = {
    instance = module.ec2_instance
    }

  name = "sendcloud-pgadmin4-loadbalancer"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.public_subnets
  security_groups = [aws_security_group.alb_sg.id]
  
  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = each.value["One"].id
          port = 80
        },
        {
          target_id = each.value["Two"].id
          port = 80
        },
      ]
    }

  ]

  # https_listeners = [
  #   {
  #     port               = 443
  #     protocol           = "HTTPS"
  #     certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
  #     target_group_index = 0
  #   }
  # ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Name        = "pgadmin4-alb-ingress"
    Environment = "development"
  }

  depends_on = [
    module.ec2_instance
  ]
}
