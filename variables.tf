# ================ RDS VARIABLES ================
# NOTE: Rds database name needs to be alfanumeric only
variable "rds_db_name" {
  type        = string
  default     = "postgres14sendcloud"
  description = "The custom database name"
}

variable "rds_db_user" {
  type        = string
  description = "The custom username for the Database"
}

# ================ PGADMIN VARIABLES ================
variable "admin_email" {
  type        = string
  description = "The admin email for PgAdmin4"
}
variable "admin_password" {
  type        = string
  description = "The admin password for PgAdmin4"
}