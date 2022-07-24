# ================ RESOURCES CREATION ================
module "general_infrastructure" {
  source = "./modules/infrastructure"

}
module "rds_database" {
  source = "./modules/database"

  db_name                     = var.rds_db_name
  db_user                     = var.rds_db_user
  vpc_id                      = module.general_infrastructure.vpc_id
  private_subnets             = module.general_infrastructure.private_subnets
  public_subnets              = module.general_infrastructure.public_subnets
  database_subnets            = module.general_infrastructure.database_subnets
  database_subnet_group       = module.general_infrastructure.database_subnet_group
  private_subnets_cidr_blocks = module.general_infrastructure.private_subnets_cidr_blocks

  depends_on = [
    module.general_infrastructure
  ]
}

module "pgadmin" {
  source = "./modules/ec2-pgadmin"

  instance_key = var.instance_key
  instance_type = var.instance_type
  
  vpc_id                      = module.general_infrastructure.vpc_id
  private_subnets             = module.general_infrastructure.private_subnets
  public_subnets              = module.general_infrastructure.public_subnets
  private_subnets_cidr_blocks = module.general_infrastructure.private_subnets_cidr_blocks
  public_subnets_cidr_blocks  = module.general_infrastructure.public_subnets_cidr_blocks
  pgadmin_admin_email         = var.admin_email
  pgadmin_admin_password      = var.admin_password

  depends_on = [
    module.general_infrastructure
  ]
}
