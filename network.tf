module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "application-vpc"
  cidr = "10.0.0.0/16"

  azs              = ["${var.region}a", "${var.region}b"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.10.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.20.0/24", "10.0.22.0/24"]

  # Nat gateway configuration
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  #necessary to have reliability into NAT gateways trough private subnets
  single_nat_gateway = false

  public_subnet_tags = {
    Access = "Public"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"

  }
}