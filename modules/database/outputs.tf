output "rds_endpoint" {
  description = "The RDS Postgres database endpoint to connect using PgAdmin4"
  value = module.db.db_instance_endpoint
}

output "rds_port" {
  description = "The RDS Postgres database port to connect"
  value = module.db.db_instance_port
}

output "rds_password" {
  description = "The RDS Random generated password to use in PgAdmin4 Connection"
  value = module.db.db_instance_password
}

output "rds_instance_arn" {
  description = "The RDS Instance ARN identification"
  value = module.db.db_instance_arn
}