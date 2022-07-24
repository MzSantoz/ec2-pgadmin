output "rds_endpoint" {
  description = "The RDS Postgres database endpoint to connect using PgAdmin4"
  value       = module.db.db_instance_endpoint
}

output "rds_user" {
  description = "The RDS Postgres database endpoint to connect using PgAdmin4"
  value       = module.db.db_instance_username
}

output "rds_port" {
  description = "The RDS Postgres database port to connect"
  value       = module.db.db_instance_port
}

output "rds_instance_arn" {
  description = "The RDS Instance ARN identification"
  value       = module.db.db_instance_arn
}