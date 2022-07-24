#security group for the database
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.db_sg_name
  description = "Security group for Postgres RDS instance."
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within Private Subnet 1"
      cidr_blocks = var.private_subnets_cidr_blocks[0]
    },
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within Private Subnet 2"
      cidr_blocks = var.private_subnets_cidr_blocks[1]
    },
  ]

  tags = {
    Name = "Postgres-Security-Group"
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.db_name

  engine                 = "postgres"
  engine_version         = "14.1"
  family                 = "postgres14" # DB parameter group
  major_engine_version   = "14"         # DB option group
  instance_class         = var.db_instance_type
  create_random_password = false
  password               = var.db_password

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = var.db_name
  username = var.db_user
  port     = 5432

  multi_az               = true
  db_subnet_group_name   = var.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Sun:00:00-Sun:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "postgres-monitoring-role-name"
  monitoring_role_use_name_prefix       = true
  monitoring_role_description           = "Role created to enable monitoring in Database"

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = {
    Name = "${var.db_name}-database"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
}